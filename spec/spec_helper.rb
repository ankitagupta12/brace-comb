# frozen_string_literal: true
require 'active_record'
require 'active_support'
require 'brace_comb'
require 'with_model'

RSpec.configure do |config|
  config.extend WithModel
end

is_jruby = RUBY_PLATFORM == 'java'
adapter = is_jruby ? 'jdbcsqlite3' : 'sqlite3'

# WithModel requires ActiveRecord::Base.connection to be established.
# If ActiveRecord already has a connection, as in a Rails app, this is unnecessary.
ActiveRecord::Base.establish_connection(adapter: adapter, database: ':memory:')

