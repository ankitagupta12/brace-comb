require 'dry-configurable'

require 'brace_comb/version'
require 'brace_comb/config'
require 'brace_comb/dependency_model'

module BraceComb
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



