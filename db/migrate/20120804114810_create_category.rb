class CreateCategory < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string  :name, :null => false
      t.string  :title
    end

    add_column :games, :category_id, :integer, :null => false
  end

  def down
    drop_table :categories

    remove_column :games, :category_id
  end
end
