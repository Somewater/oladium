class AddPrimaryToGame < ActiveRecord::Migration
  def change
    add_column :games, :primary, :integer, default: 0
  end
end
