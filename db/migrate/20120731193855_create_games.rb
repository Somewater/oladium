class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.string  :net, :null => false
      t.string  :net_id, :null => false
      t.string  :type
      t.string  :slug
      t.string  :title
      t.text    :description
      t.string  :driving
      t.integer :priority, :default => 0
      t.text    :body
      t.integer :width, :default => 0
      t.integer :height, :default => 0
      t.string  :image
      t.string  :tags

      t.timestamps
    end

    add_index :games, ["net", "net_id"], :unique => true
  end

  def down
    drop_table :games

    remove_index :games, :column => ["net", "net_id"]
  end
end
