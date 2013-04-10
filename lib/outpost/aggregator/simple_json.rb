module Outpost
  module Aggregator
    module SimpleJson
      def simple_json
        @simple_json ||= {
          "id"          => self.content.try(:obj_key),
          "position"    => self.position.to_i
        }
      end
    end
  end
end
