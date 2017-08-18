require 'brace_comb/exceptions/callback_failure'

module BraceComb
  module Model
    module InstanceMethods
      # throws an exception if before callbacks return false
      # throws an exception if before, after callbacks or resolver raises an exception
      # rolls back the transaction if before callbacks return false or if any exception is raised
      def resolve!(args = nil)
        dependency_mapping = self.class.
          instance_variable_get(:@dependency_mapping)[self.dependency_type.to_sym]
        ActiveRecord::Base.transaction do
          execute_before_callbacks(dependency_mapping[:before_resolution])
          execute_resolver(dependency_mapping[:resolver], args)
          execute_after_callbacks(dependency_mapping[:after_resolution])
        end
      end

      # returns false if before callbacks return false
      # throws an exception if before, after callbacks or resolver raises an exception
      # rolls back the transaction if before callbacks return false or if any exception is raised
      def resolve(args = nil)
        resolve!(args)
        true
      rescue BraceComb::Exceptions::CallbackFailure
        false
      end

      def execute_after_callbacks(after_callbacks)
        after_callbacks.each do |after_callback|
          execute_callback(after_callback)
        end
      end

      # Resolver can be a proc or method
      def execute_resolver(resolver, args)
        return resolver.call(self) if resolver.respond_to?(:call)
        if method(resolver).arity.zero?
          __send__(resolver)
        else
          __send__(resolver, args)
        end
      end

      def execute_before_callbacks(before_callbacks)
        before_callbacks.each do |before_callback|
          result = execute_callback(before_callback)
          raise BraceComb::Exceptions::CallbackFailure.new unless result
        end
      end

      # Callbacks can be procs or methods
      def execute_callback(callback)
        if callback.respond_to?(:call)
          callback.call(self)
        else
          __send__(callback)
        end
      end
    end

    def self.included(base)
      base.send :include, InstanceMethods
    end
  end
end
