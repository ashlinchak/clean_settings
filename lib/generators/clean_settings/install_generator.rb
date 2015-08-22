require 'rails/generators/migration'

class CleanSettings::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def generate_files
    migration_template 'migration.rb', 'db/migrate/clean_settings_migration.rb'
  end
end