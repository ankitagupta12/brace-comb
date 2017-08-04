require "rails/generators"
require "rails/generators/active_record"
module JobDependencies
  # Installs job dependencies migrations
  class InitializerGenerator < Rails::Generators::Base
    include ::Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      add_job_dependencies_migrations('create_jobs')
      add_job_dependencies_migrations('create_job_dependencies')
      add_job_dependencies_migrations('add_job_dependencies_associations')
    end

    private

    def add_job_dependencies_migrations(template)
      migration_dir = File.expand_path("db/migrate")
      if migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/#{template}.rb",
          migration_version: migration_version
        )
      end
    end

    def migration_exists?(migration_dir, template)
      [template.singularize, template.pluralize].any? do |template|
        self.class.migration_exists?(migration_dir, template)
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
