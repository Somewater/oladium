class CreateMinecraftUsers < ActiveRecord::Migration
  def change
    create_table :minecraft_users do |t|
      t.string :login, :null => false
      t.string :password
      t.string :session
      t.datetime :session_start
      t.string :server
      
      t.boolean :premium, :default => false
      t.integer :money, :default => 0
      t.integer :permissions, :default => 0

      t.timestamps
    end
    
    add_index(:minecraft_users, :login, :unique => true)
  end
end
