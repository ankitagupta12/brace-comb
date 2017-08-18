require 'spec_helper'
require 'brace_comb/dependency_helper'
require 'brace_comb/dependency_model'
require 'pry'
describe BraceComb::Model do
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

  before do
    dependency_class.constantize.class_eval do
      include BraceComb::Helper

      enum dependency_type: { shopping: 0 }
      enum status: { pending: 0, resolved: 1 }

      declare_dependency type: :shopping,
                         resolver: :mark_as_complete,
                         before_resolution: [:before_resolve1?, :before_resolve2?],
                         after_resolution: [:complete_job]
    end
  end

  let(:source) { dependent_class.constantize.create }
  let(:destination) { dependent_class.constantize.create }
  let(:dependency) do
    dependency_class.constantize.new.initialize_dependency!(
      from: source.id,
      to: destination.id,
      dependency_type: :shopping
    )
  end

  context '#resolve' do
    context 'resolve using a function' do
      context 'before resolve callbacks not satisfied' do
        before do
          class JobDependency
            def before_resolve1?
              true
            end

            def before_resolve2?
              false
            end

            def mark_as_complete
              resolved!
            end
          end
        end

        it 'does not resolve dependency if all before resolve hooks are not satisfied' do
          result = dependency.resolve
          expect(dependency).not_to be_resolved
          expect(result).to be false
        end
      end

      context 'before resolve callbacks are satisfied' do
        before do
          class JobDependency
            def before_resolve1?
              true
            end

            def before_resolve2?
              true
            end

            def mark_as_complete
              resolved!
            end

            def complete_job
              true
            end
          end
        end

        it 'resolves dependency if no exceptions are raised' do
          result = dependency.resolve
          expect(dependency).not_to receive(:complete_job).and_call_original
          expect(dependency).to be_resolved
          expect(result).to be true
        end
      end
    end

    context 'resolve using a proc' do
      before do
        dependency_class.constantize.class_eval do
          declare_dependency type: :shopping,
                             resolver: ->(data) { data.resolved! },
                             before_resolution: [->(_) { true }, :before_resolve?],
                             after_resolution: [:complete_job]
        end

        class JobDependency
          def before_resolve?
            true
          end

          def complete_job
            true
          end
        end
      end

      it 'resolves dependency if all before resolve hooks are satisfied' do
        result = dependency.resolve
        expect(dependency).not_to receive(:complete_job).and_call_original
        expect(dependency).to be_resolved
        expect(result).to be true
      end
    end
  end

  context 'resolve' do
    context 'before resolve callbacks not satisfied' do
      before do
        class JobDependency
          def before_resolve1?
            true
          end

          def before_resolve2?
            false
          end

          def mark_as_complete
            resolved!
          end
        end
      end

      it 'does not resolve dependency if all before resolve hooks are not satisfied' do
        expect { dependency.resolve! }.to raise_error(BraceComb::Exceptions::CallbackFailure)
      end
    end
  end
end
