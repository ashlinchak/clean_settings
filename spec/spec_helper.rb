$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'bundler/setup'
require "active_record"
require 'active_support'
require 'sqlite3'
require 'clean_settings'

Bundler.setup

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :clean_settings do |t|
      t.string :var, null: false
      t.text :value, null: false
      t.integer :owner_id,   null: true
      t.string  :owner_type, null: true, limit: 30
      t.timestamps null: false
    end

    create_table :users do |t|
      t.string :name
      t.string :email
      t.timestamps null: false
    end
  end
end

setup_db

def clean_database
  User.delete_all
  CleanSetting.delete_all
end

RSpec.configure do |config|
  config.before :each do
    clean_database
  end

  config.after :suite do
    require File.expand_path('../../lib/generators/clean_settings/templates/migration.rb', __FILE__)

    CreateConfirmedAttributesTables.migrate(:down)
  end
end

class CleanSetting < CleanSettings::Setting
end


class User < ActiveRecord::Base
  has_settings
end