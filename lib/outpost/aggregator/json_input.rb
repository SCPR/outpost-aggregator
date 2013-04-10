module Outpost
  module Aggregator
    module JsonInput
      extend ActiveSupport::Concern

      module ClassMethods
        def accepts_json_input_for_content(options={})
          include InstanceMethodsOnActivation

          @content_association_name = options[:name] || :content
          @content_association_join_class = self.reflect_on_association(@content_association_name).klass
          
          @content_association_join_class.send :include, JoinModelMethodsOnActivation
        end


        def content_association_name
          @content_association_name
        end


        def content_association_join_class
          @content_association_join_class
        end
      end


      module JoinModelMethodsOnActivation
        def simple_json
          @simple_json ||= {
            "id"          => self.content.try(:obj_key),
            "position"    => self.position.to_i
          }
        end
      end


      module InstanceMethodsOnActivation
        def content_changed?
          attribute_changed?(self.class.content_association_name.to_s)
        end

        #-------------------
        # #content_json is a way to pass in a string representation
        # of a javascript object to the model, which will then be
        # parsed and turned into content objects in the 
        # #content_json= method.
        def content_json
          current_content_json.to_json
        end

        #-------------------
        # See AssetAssociation for more information
        def content_json=(json)
          return if json.empty?
          
          json = Array(JSON.parse(json)).sort_by { |c| c["position"].to_i }
          loaded_content = []
          
          json.each do |content_hash|
            # Make sure the content actually exists, and that it's
            # published, then build the association.
            content = Outpost.obj_by_key(content_hash["id"])
            if content && content.published?
              new_content = build_content_association(content_hash, content)
              loaded_content.push new_content
            end
          end

          loaded_content_json = content_to_simple_json(loaded_content)

          if current_content_json != loaded_content_json
            self.changed_attributes[self.class.content_association_name.to_s] = current_content_json
            self.send("#{self.class.content_association_name}=", loaded_content)
          end

          self.send(self.class.content_association_name)
        end


        private

        def build_content_association(content_hash, content)
          raise "build_content_association needs to be defined in your model."
        end

        def current_content_json
          content_to_simple_json(self.send(self.class.content_association_name))
        end

        def content_to_simple_json(array)
          Array(array).map(&:simple_json)
        end
      end
    end
  end
end
