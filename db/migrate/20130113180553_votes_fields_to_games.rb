class VotesFieldsToGames < ActiveRecord::Migration
  def up
    add_column :games, :votes, :integer, :default => 0
    add_column :games, :votings, :integer, :default => 0
    add_column :games, :usage, :integer, :default => 0
  end

  def down
    remove_column :games, :votes
    remove_column :games, :votings
    remove_column :games, :usage
  end
end
