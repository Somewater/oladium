class CreateDeveloperUser < ActiveRecord::Migration
  def up
    create_table :developers do |t|
      ## Database authenticatable
      t.string :login,              :null => false
      t.string :email,              :null => false
      t.string :encrypted_password, :null => false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :developers, :email,                :unique => true
    add_index :developers, :login,                :unique => true
    add_index :developers, :reset_password_token, :unique => true

    add_column :games, :developer_id, :integer
  end

  def down
    drop_table :developer_users
    remove_column :games, :developer_id
  end
end
