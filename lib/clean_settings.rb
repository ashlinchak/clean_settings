require 'ostruct'
require "clean_settings/version"
require "clean_settings/setting"
require "clean_settings/ownerable"
require "clean_settings/has_settings"

module CleanSettings
  ActiveRecord::Base.extend CleanSettings::HasSettings
end
