class CreateConfirmedAttributesTables < ActiveRecord::Migration
  def self.up
    create_table :clean_settings do |t|
      t.string :var, null: false
      t.text :value, null: false
      t.integer :owner_id,   null: true
      t.string  :owner_type, null: true, limit: 30

      t.timestamps
    end

    add_index :clean_settings, [:owner_type, :owner_id, :var], unique: true
  end

  def self.down
    drop_table :clean_settings
  end
end