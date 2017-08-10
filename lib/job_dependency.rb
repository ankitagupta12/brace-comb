require 'dry-configurable'

require 'job_dependency/version'
require 'job_dependency/config'
require 'job_dependency/dependency_model'
require 'job_dependency/dependency_helper'

module JobDependency
  class << self
    # return config
    def config
      Config.config
    end

    # Provides a block to override default config
    def setup(&block)
      Config.setup(&block)
    end

    def dependency_model
      config.dependency_table_name.singularize.camelize
    end

    def dependent_model
      config.dependent_table_name.singularize.camelize
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include JobDependency::Helper
end


