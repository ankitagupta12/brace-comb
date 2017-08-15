require 'rails/generators'
module BraceComb
  # creates job depedency initializer
  class InitializerGenerator < Rails::Generators::Base
    def create_initializer
      create_file(
        'config/initializers/brace_comb.rb',
        "BraceComb.setup do |config|\n"\
          " config.dependent_table_name = 'jobs'\n"\
          " config.dependency_table_name = 'dependencies'\n"\
          "end"
      )
    end
  end
end