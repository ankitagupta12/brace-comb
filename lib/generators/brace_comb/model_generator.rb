require 'rails/generators/active_record'
require 'brace_comb'
module BraceComb
  # creates job depedency initializer
  class ModelGenerator < ActiveRecord::Generators::Base
    def generate_model
      invoke 'active_record:model',
             [dependency_model],
             migration: false unless model_exists? && behavior == :invoke
    end

    def inject_model_content
      content = model_contents
      class_path = [dependency_model.camelize]
      indent_depth = class_path.size - 1
      content = content.split('\n').map { |line| '  ' * indent_depth + line } .join('\n')
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
        enum status: { pending: 0, resolved: 1 }
      CONTENT
    end
  end
end
