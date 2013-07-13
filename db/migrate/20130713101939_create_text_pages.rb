class CreateTextPages < ActiveRecord::Migration
  def up
    create_table "text_pages", :force => true do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "title_ru"
      t.string   "title_en"
      t.text     "body_ru"
      t.text     "body_en"
    end

    add_index "text_pages", ["name"], :name => "index_text_pages_on_name", :unique => true
  end

  def down
    drop_table "text_pages"
  end
end
