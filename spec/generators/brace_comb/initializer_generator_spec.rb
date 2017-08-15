require 'generator_spec/test_case'
require 'generators/brace_comb/initializer_generator'

describe BraceComb::InitializerGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __FILE__)

  after(:all) { prepare_destination }

  context '#create_initializer' do
    before(:all) do
      prepare_destination
      run_generator
    end

    it 'creates brace comb initializer' do
      assert_file 'config/initializers/brace_comb.rb', "BraceComb.setup do |config|\n"\
        " config.dependent_table_name = 'jobs'\n"\
        " config.dependency_table_name = 'job_dependencies'\n"\
        "end"
    end
  end
end