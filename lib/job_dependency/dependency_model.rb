require 'job_dependency/exceptions/callback_failure'

module JobDependency
  module Model
    module InstanceMethods
      # throws an exception if before callbacks return false
      # throws an exception if before, after callbacks or resolver raises an exception
      # rolls back the transaction if before callbacks return false or if any exception is raised
      def resolve!(args = {})
        dependency_mapping = self.class.
            instance_variable_get(:@dependency_mapping)[self.type.to_sym]
        ActiveRecord::Base.transaction do
          execute_before_callbacks(dependency_mapping[:before_resolved])
          __send__(dependency_mapping[:resolver], args)
          execute_after_callbacks(dependency_mapping[:after_resolved])
        end
      end

      # returns false if before callbacks return false
      # throws an exception if before, after callbacks or resolver raises an exception
      # rolls back the transaction if before callbacks return false or if any exception is raised
      def resolve(args = {})
       resolve!(args)
      rescue JobDependency::Exceptions::CallbackFailure
        false
      end

      def execute_after_callbacks(after_callbacks)
        after_callbacks.each do |after_callback|
          execute_callback(after_callback)
        end
      end

      def execute_before_callbacks(before_callbacks)
        before_callbacks.each do |before_callback|
          result = execute_callback(before_callback)
          raise JobDependency::Exceptions::CallbackFailure.new unless result
        end
      end

      def execute_callback(callback)
        if callback.respond_to?(:call)
          callback.call
        else
          __send__(callback)
        end
      end
    end
  end
end
