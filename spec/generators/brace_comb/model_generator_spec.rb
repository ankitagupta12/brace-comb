require 'generator_spec/test_case'
require 'generators/brace_comb/model_generator'

describe BraceComb::ModelGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __FILE__)

  after(:all) { prepare_destination }

  context '#generate_model' do
    before(:all) do
      prepare_destination
      run_generator %w('')
    end

    it 'creates a model' do
      expect(destination_root).to have_structure {
        directory 'app' do
          directory 'models' do
            file 'job_dependency.rb' do
              contains('class JobDependency < ApplicationRecord')
              contains('enum status: { pending: 0, resolved: 1 }')
            end
          end
        end
      }
    end
  end
end
