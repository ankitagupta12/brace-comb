require 'rails/generators'
module JobDependency
  # creates job depedency initializer
  class InitializerGenerator < Rails::Generators::Base
    def create_initializer
      create_file(
        'config/initializers/job_dependency.rb',
        "JobDependency.setup do |config|\n"\
          " config.dependent_table_name = 'jobs'\n"\
          " config.dependency_table_name = 'job_dependencies'\n"\
          "end"
      )
    end
  end
end