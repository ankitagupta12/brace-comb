module BraceComb
  module Helper
    module ClassMethods
      # declare_dependency
      #   type: :shopping
      #   resolver: :shopping_completed
      #   before_resolved: [:completed_status?]
      #   after_resolved: :complete_job, Proc.new {}
      # Options:
      # resolver: Methods or procs that can mark the dependency as resolved
      # before_resolved: Checks that can be performed before a dependency is resolved.
      # If any of these return false then the dependency resolution will result in a false
      # or exception.
      # after_resolved: if the dependency resolution succeeds, each of these methods will be
      # executed one by one. All the subsequent after_resolved hooks will not be executed if any
      # of the predecessor after_resolved hook throws an exception. However, this will not make
      # a difference to the resolution status of the dependency itself
      def declare_dependency(options = {})
        dependency_mapping = dependency_mapping_value
        dependency_mapping[options[:type]] = options.slice(
          :resolver,
          :before_resolved,
          :after_resolved
        )
        set_dependency_mapping(dependency_mapping)
      end

      # initialize_dependency from: job1, to: job2, type: 'shopping'
      def initialize_dependency(from:, to:, type:)
        dependency_model.create(
          from: from,
          to: to,
          type: type,
          status: :pending
        )
      end

      # initialize_dependency from: job1, to: job2, type: 'shopping'
      def initialize_dependency!(from:, to:, type:)
        dependency_model.create!(
          from: from,
          to: to,
          type: type,
          status: :pending
        )
      end

      def dependency_mapping_value
        klass = dependency_model
        dependency_mapping = klass.instance_variable_get(:@dependency_mapping)
        value = dependency_mapping || {}
        value.tap do |dependency_mapping_value|
          klass.instance_variable_set(:@dependency_mapping, dependency_mapping_value)
        end
      end

      def set_dependency_mapping(value)
        dependency_model.instance_variable_set(:@dependency_mapping, value)
      end

      def dependency_model
        ::BraceComb.dependency_model.constantize
      end

      # private_class_method :dependency_mapping_value, :set_dependency_mapping
    end

    def self.included(base)
      base.send :extend, ClassMethods
    end
  end
end
