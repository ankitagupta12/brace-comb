require 'rails/generators/active_record'
require 'pry'
module BraceComb
  # creates job depedency initializer
  class ModelGenerator < ActiveRecord::Generators::Base
    def generate_model
      invoke "active_record:model",
             [name],
             migration: false unless model_exists? && behavior == :invoke
    end

    def inject_model_content
      content = model_contents

      class_path = if namespaced?
                     class_name.to_s.split("::")
                   else
                     [class_name]
                   end

      indent_depth = class_path.size - 1
      content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

      inject_into_class(model_path, class_path.last, content) if model_exists?
    end

    private

    def dependency_model
      ::BraceComb.dependency_model.to_s.underscore
    end

    def model_exists?()
      File.exist?(File.join(destination_root, model_path))
    end

    def model_path
      @model_path ||= File.join('app', 'models', "#{dependency_model}.rb")
    end

    def model_contents
      <<-CONTENT
        enum status: { pending: 0, resolved: 2 }
      CONTENT
    end
  end
end