class RemoveRequirementsFromSomeFileds < ActiveRecord::Migration
  def up
    change_column :games, :net, :string, null: true
    change_column :games, :net_id, :string, null: true
    change_column :games, :type, :string, null: false
  end

  def down
    change_column :games, :net, :string, null: false
    change_column :games, :net_id, :string, null: false
    change_column :games, :type, :string, null: true
  end
end
