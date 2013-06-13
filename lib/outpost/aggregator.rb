require "outpost/aggregator/version"
require "outpost/aggregator/json_input"
require "outpost/aggregator/simple_json"

module Outpost
  module Aggregator
    module Rails
      class Engine < ::Rails::Engine
        config.to_prepare do
          ActiveSupport.on_load(:active_record) do
            ActiveRecord::Base.send :include, Outpost::Aggregator::JsonInput
          end
        end
      end
    end # Rails

    def self.array_to_simple_json(array)
      Array(array).map(&:simple_json)
    end
  end # Aggregator
end # Outpost
