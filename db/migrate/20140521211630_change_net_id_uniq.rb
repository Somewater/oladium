class ChangeNetIdUniq < ActiveRecord::Migration
  def up

    remove_index! 'games', "index_games_on_net_and_net_id"

    execute <<-SQL
CREATE UNIQUE INDEX index_games_on_net_and_net_id_without_nulls
ON games (net, net_id)
WHERE net IS NOT NULL AND net_id IS NOT NULL;
    SQL
  end

  def down
    remove_index! 'games', "index_games_on_net_and_net_id_without_nulls"
    add_index "games", ["net", "net_id"], :name => "index_games_on_net_and_net_id", :unique => true
  end
end
