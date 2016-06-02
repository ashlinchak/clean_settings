module CleanSettings
  module HasSettings
    def has_settings
      send :include, HasSettings::InstanceMethods

      scope :with_setting, lambda { |var|
        joins("JOIN clean_settings ON (clean_settings.owner_id = #{self.table_name}.#{self.primary_key} AND
         clean_settings.owner_type = '#{self.base_class.name}') AND clean_settings.var = '#{var}'")
      }
    end

    module InstanceMethods
      def settings
        CleanSettings::Ownerable.for_thing(self)
      end
    end
  end
end
