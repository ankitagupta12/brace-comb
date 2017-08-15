require 'generator_spec/test_case'
require 'generators/brace_comb/migration_generator'

describe BraceComb::MigrationGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __FILE__)

  after(:all) { prepare_destination }

  context '#create_migration_file' do
    before(:all) do
      prepare_destination
      run_generator
    end

    it 'generates migrations' do
      parent_class =  lambda {
        old_version = 'ActiveRecord::Migration'
        new_version = ActiveRecord::VERSION
        if new_version::MAJOR >= 5
          format("%s[%d.%d]", old_version, new_version::MAJOR, new_version::MINOR)
        else
          old_version
        end
      }.call
      expect(destination_root).to have_structure {
        directory 'db' do
          directory 'migrate' do
            migration 'jobs' do
              contains('class CreateJobs < ' + parent_class)
              contains('create_table :jobs do |t|')
              contains('t.timestamps null: false')
            end
            migration 'job_dependencies' do
              contains('create_table :job_dependencies do |t|')
              contains('class CreateJobDependencies < ' + parent_class)
              contains('t.integer :type')
              contains('t.integer :status')
              contains('t.integer :source_id')
              contains('t.integer :destination_id')
              contains('t.timestamps null: false')
            end
            migration 'add_associations' do
              contains('class AddAssociations < ' + parent_class)
              contains('add_foreign_key :job_dependencies, :jobs, column: :source_id, dependent: :delete')
              contains('add_foreign_key :job_dependencies, :jobs, column: :destination_id, dependent: :delete')
            end
          end
        end
      }
    end
  end
end