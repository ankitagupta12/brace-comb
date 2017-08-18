require 'spec_helper'
require 'brace_comb/dependency_helper'

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
  context 'dependency_helper' do
    let(:source) { dependent_class.constantize.create }
    let(:destination) { dependent_class.constantize.create }

    context '#declare_dependency' do
      before do
        dependency_class.constantize.class_eval do
          include BraceComb::Helper

          declare_dependency type: :shopping,
                             resolver: :shopping_complete,
                             before_resolution: [:completed_status?],
                             after_resolution: [:complete_job]
        end
      end
      it 'can declare dependency' do
        dependency_mapping = JobDependency.instance_variable_get(:@dependency_mapping)
        expect(dependency_mapping).to match(
          shopping: {
            resolver: :shopping_complete,
            before_resolution: [:completed_status?],
            after_resolution: [:complete_job]
          }
        )
      end
    end

    context '#initialize_dependency' do
      before do
        dependency_class.constantize.class_eval do
          include BraceComb::Helper
          enum dependency_type: {shopping: 0}

          validates :source_id, presence: true
        end
      end

      let(:new_dependency) do
        dependency_class.constantize.new.initialize_dependency(
          from: source.id,
          to: destination.id,
          dependency_type: :shopping
        )
      end

      it 'creates a dependency' do
        expect(new_dependency.present?).to eq(true)
        expect(new_dependency.source_id).to eq(source.id)
        expect(new_dependency.destination_id).to eq(destination.id)
        expect(new_dependency.dependency_type).to eq('shopping')
      end

      it 'returns false if a dependency cannot be created' do
        dependency = dependency_class.constantize.new.initialize_dependency
        expect(dependency.valid?).to be false
      end
    end

    context '#initialize_dependency!' do
      before do
        dependency_class.constantize.class_eval do
          include BraceComb::Helper

          enum dependency_type: {shopping: 0}
          validates :source_id, presence: true
        end
      end

      let(:new_dependency) do
        dependency_class.constantize.new.initialize_dependency!(
          from: source.id,
          to: destination.id,
          dependency_type: :shopping
        )
      end

      it 'creates a dependency' do
        expect(new_dependency.present?).to eq(true)
        expect(new_dependency.source_id).to eq(source.id)
        expect(new_dependency.destination_id).to eq(destination.id)
        expect(new_dependency.dependency_type).to eq('shopping')
      end

      it 'raises error if a dependency cannot be created' do
        expect { dependency_class.constantize.new.initialize_dependency! }.to raise_error
      end
    end
  end
end
