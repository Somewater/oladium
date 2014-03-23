class AddGameNetData < ActiveRecord::Migration
  def up
    add_column :games, :net_data, :text
  end

  def down
    remove_column :games, :net_data
  end
end
