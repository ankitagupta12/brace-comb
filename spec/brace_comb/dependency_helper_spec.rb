require 'spec_helper'
require 'brace_comb/dependency_helper'
require 'pry'
require 'factories/dependency_table'

describe BraceComb::Helper do
  dependency_class = ::BraceComb.dependency_model
  dependent_class = ::BraceComb.dependent_model
  with_model dependency_class do
    table do |t|
      t.integer :dependency_type
      t.integer :status
      t.integer :source_id
      t.integer :destination_id
      t.timestamps null: false
    end
  end

  with_model dependent_class do
    table do |t|
      t.timestamps null: false
    end
  end

  context '#declare_dependency' do
    before do
      dependency_class.constantize.class_eval do
        declare_dependency type: :shopping,
                           resolver: :shopping_complete,
                           before_resolved: [:completed_status?],
                           after_resolved: [:complete_job]
      end
    end
    it 'can declare dependency' do
      dependency_mapping = JobDependency.instance_variable_get(:@dependency_mapping)
      expect(dependency_mapping).to match(
        shopping: {
          resolver: :shopping_complete,
          before_resolved: [:completed_status?],
          after_resolved: [:complete_job]
        }
      )
    end
  end

  context 'initialize_dependency' do
    before do
      @source = dependent_class.constantize.create
      @destination = dependent_class.constantize.create
      dependency_class.constantize.class_eval do
        enum dependency_type: { shopping: 0 }
        validates :source_id, presence: true
      end
    end

    let(:new_dependency) do
      dependency_class.constantize.new.initialize_dependency(
        from: @source.id,
        to: @destination.id,
        dependency_type: :shopping
      )
    end

    it 'creates a dependency' do
      expect(new_dependency.present?).to eq(true)
      expect(new_dependency.source_id).to eq(@source.id)
      expect(new_dependency.destination_id).to eq(@destination.id)
      expect(new_dependency.dependency_type).to eq('shopping')
    end

    it 'returns false if a dependency cannot be created' do
      dependency = dependency_class.constantize.new.initialize_dependency
      expect(dependency.valid?).to be false
    end
  end

  context 'initialize_dependency' do
    before do
      @source = dependent_class.constantize.create
      @destination = dependent_class.constantize.create
      dependency_class.constantize.class_eval do
        enum dependency_type: { shopping: 0 }
        validates :source_id, presence: true
      end
    end

    let(:new_dependency) do
      dependency_class.constantize.new.initialize_dependency!(
        from: @source.id,
        to: @destination.id,
        dependency_type: :shopping
      )
    end

    it 'creates a dependency' do
      expect(new_dependency.present?).to eq(true)
      expect(new_dependency.source_id).to eq(@source.id)
      expect(new_dependency.destination_id).to eq(@destination.id)
      expect(new_dependency.dependency_type).to eq('shopping')
    end
  end
end