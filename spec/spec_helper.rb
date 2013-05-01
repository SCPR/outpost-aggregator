require 'combustion'

unless defined?(RAKED)
  Bundler.require :default, :test
  Combustion.initialize! :active_record
end

require 'rspec/rails'
require 'factory_girl'
load 'factories.rb'

Rails.backtrace_cleaner.remove_silencers!


Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.infer_base_class_for_anonymous_controllers = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
