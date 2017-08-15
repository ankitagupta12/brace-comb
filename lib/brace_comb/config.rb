# frozen_string_literal: true
module BraceComb
  # configurator for setting up all the configurable settings for job dependency
  class Config
    extend Dry::Configurable
      # defines the table name between which dependencies are created
    setting :dependent_table_name, 'job'
    setting :dependency_table_name, 'job_dependency'

    class << self
      def setup
        configure do |config|
          yield(config)
        end
      end
    end
  end
end
