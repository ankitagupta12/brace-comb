require 'dry-configurable'

require 'job_dependency/version'
require 'job_dependency/config'
require 'job_dependency/declare_dependency'

module JobDependency
  class << self
    # return config
    def config
      Config.config
    end

    def setup(&block)
      Config.setup(&block)
    end
  end
end
