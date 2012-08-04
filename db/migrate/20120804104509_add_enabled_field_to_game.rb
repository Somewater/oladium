class AddEnabledFieldToGame < ActiveRecord::Migration
  def up
    add_column :games, :enabled, :boolean, :default => true
  end

  def down
    remove_column :games, :enabled
  end
end
