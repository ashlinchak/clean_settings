module CleanSettings
  class Ownerable < Setting
    def self.for_thing(object)
      @object = object
      self
    end

    def self.with_owner
      unscoped.where(owner_type: @object.class.base_class.to_s, owner_id: @object.id)
    end
  end
end