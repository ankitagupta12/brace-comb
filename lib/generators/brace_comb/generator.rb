require 'brace_comb'
module BraceComb
  class Generator < Rails::Generators::Base
    private

    def dependent_table_name
      ::BraceComb.config.dependent_table_name.pluralize.downcase
    end

    def dependency_table_name
      ::BraceComb.config.dependency_table_name.pluralize.downcase
    end
  end
end