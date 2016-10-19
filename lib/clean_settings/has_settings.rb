module CleanSettings
  module HasSettings
    def has_settings(opts = {})
      opts[:method_name] = :settings unless opts.key?(:method_name)

      instance_eval do
        define_method opts[:method_name].to_sym do
          CleanSettings::Ownerable.for_thing(self)
        end
      end

      scope :with_setting, lambda { |var|
        joins("JOIN clean_settings ON (clean_settings.owner_id = #{self.table_name}.#{self.primary_key} AND
         clean_settings.owner_type = '#{self.base_class.name}') AND clean_settings.var = '#{var}'")
      }
    end
  end
end
