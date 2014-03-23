class CreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string :key, :null => false
      t.string :value
    end

    add_index "settings", "key", :unique => true
  end

  def down
    drop_table :settings
  end
end
