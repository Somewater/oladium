class AddGameSlugUniq < ActiveRecord::Migration
  def up
    add_index :games, :slug, :unique => true, :name => 'index_games_on_slug'
  end

  def down
    remove_index 'index_games_on_slug'
  end
end

