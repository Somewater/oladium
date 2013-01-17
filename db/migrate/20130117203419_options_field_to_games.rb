class OptionsFieldToGames < ActiveRecord::Migration
  def up
    add_column :games, :options, :string
  end

  def down
    remove_column :games, :options
  end
end
