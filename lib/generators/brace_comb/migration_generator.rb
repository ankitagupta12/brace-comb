require 'generators/brace_comb/generator'
require 'rails/generators'
require 'rails/generators/active_record'
module BraceComb
  # Installs job dependencies migrations
  class MigrationGenerator < Generator
    include ::Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      add_migrations(dependent_table_name, 'create_dependent')
      add_migrations(dependency_table_name, 'create_dependencies')
      add_migrations('associations', 'add_associations')
    end

    private

    def add_migrations(table_name, template)
      migration_dir = File.expand_path("db/migrate")
      migration_name = table_name || template
      if migration_exists?(migration_dir, migration_name)
        ::Kernel.warn "Migration already exists: #{migration_name}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/create_#{migration_name.pluralize}.rb",
          migration_version: migration_version
        )
      end
    end

    def migration_exists?(migration_dir, table_name)
      [table_name.singularize, table_name.pluralize].any? do |table|
        self.class.migration_exists?(migration_dir, "create_#{table}")
      end
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def migration_version
      major = ActiveRecord::VERSION::MAJOR
      "[#{major}.#{ActiveRecord::VERSION::MINOR}]" if major >= 5
    end
  end
end
