module Outpost
  module Aggregator
    module JsonInput
      extend ActiveSupport::Concern

      module ClassMethods
        def accepts_json_input_for(name)
          include InstanceMethodsOnActivation

          # The current collection as simple_json
          define_method "current_#{name}_json" do
            current_json_for(name)
          end

          # The current collection as simple_json and then
          # converted to real JSON.
          define_method "#{name}_json" do
            current_json_for(name).to_json
          end

          define_method "#{name}_json=" do |json|
            process_json_input_for(name.to_s, json)
          end
        end
      end


      module InstanceMethodsOnActivation
        def current_json_for(name)
          Aggregator.array_to_simple_json(self.send(name))
        end

        def process_json_input_for(name, json)
          return if json.empty?
          name = name.to_s
          
          json = Array(JSON.parse(json)).sort_by { |c| c["position"].to_i }
          loaded = []
          
          json.each do |object_hash|
            if object = Outpost.obj_by_key(object_hash["id"])
              new_object = build_association_for(name, object_hash, object)
              loaded.push(new_object) if new_object
            end
          end

          loaded_json  = Aggregator.array_to_simple_json(loaded)
          current_json = current_json_for(name)
          
          if current_json != loaded_json
            # Secretary hook
            if self.class.respond_to?(:versioned_attributes) &&
            self.class.versioned_attributes.include?(name)
              send("#{name}_will_change!")
            end

            # This actually opens a DB transaction and saves stuff.
            # This is Rails behavior.
            self.send("#{name}=", loaded)
          end

          self.send(name)
        end


        private

        def build_association_for(name, object_hash, object)
          self.send("build_#{name.singularize}_association", object_hash, object)
        end
      end
    end
  end
end
