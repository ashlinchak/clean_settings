module CleanSettings
  class Setting < ActiveRecord::Base
    self.table_name = "clean_settings"

    class SettingNotFound < RuntimeError; end
    class Defaults < OpenStruct
      def [](name)
        send name.to_sym
      end

      def []=(name, value)
        send "#{name.to_sym}=", value
      end
    end

    @@defaults = Defaults.new

    def value
      YAML::load(self[:value])
    end

    def value=(new_value)
      self[:value] = new_value.to_yaml
    end

    class << self
      def defaults
        @@defaults ||= Defaults.new
      end

      def fetch_defaults
        @@defaults.marshal_dump.with_indifferent_access
      end
      alias_method :all_defaults, :fetch_defaults

      def defaults=(key, value)
        @@defaults.send("#{key}=", value)
      end

      def clear_defaults
        @@defaults = Defaults.new
      end

      def [](var_name)
        if var = object(var_name)
          var.value
        elsif @@defaults.send(var_name.to_sym)
          @@defaults.send(var_name.to_sym)
        else
          nil
        end
      end

      def []=(var_name, value)
        var_name = var_name.to_s

        record = object(var_name) || with_owner.new(var: var_name)
        record.value = value
        record.save!

        value
      end

      def destroy(var_name)
        var_name = var_name.to_s

        if obj = object(var_name)
          obj.destroy
          true
        else
          raise SettingNotFound, "Setting variable \"#{var_name}\" not found"
        end
      end

      def fetch_globals
        vars = with_owner.select([:var, :value])

        result = {}
        vars.each { |record| result[record.var] = record.value }
        result.with_indifferent_access
      end
      alias_method :all_globals, :fetch_globals

      def fetch
        fetch_defaults.merge(fetch_globals)
      end
      alias_method :all_settings, :fetch


      def for_thing(owner)
        @owner = owner
        self
      end

      def with_owner
        unscoped.where("owner_type is NULL and owner_id is NULL")
      end

      def object(var_name)
        with_owner.where(var: var_name).first
      end

      def method_missing(method, *args, &block)
        method_name = method.to_s
        super(method, *args, &block)

      rescue NoMethodError

        if method_name[-1] == "="
          var_name = method_name.chop
          value = args[0]
          self[var_name] = value
        else
          self[method_name]
        end
      end
    end
  end
end
