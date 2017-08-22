require 'generators/brace_comb/generator'
require 'rails/generators'
module BraceComb
  # creates job depedency initializer
  class InitializerGenerator < Generator
    def create_initializer
      create_file(
        'config/initializers/brace_comb.rb',
        "BraceComb.setup do |config|\n"\
          "  config.dependent_table_name = '#{dependent_table_name}'\n"\
          "  config.dependency_table_name = '#{dependency_table_name}'\n"\
          "end"
      )
    end
  end
end