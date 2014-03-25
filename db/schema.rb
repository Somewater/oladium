# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140323232906) do

  create_table "categories", :force => true do |t|
    t.string "name",     :null => false
    t.string "title_ru"
    t.string "title_en"
  end

  create_table "developers", :force => true do |t|
    t.string   "login",                                 :null => false
    t.string   "email",                                 :null => false
    t.string   "encrypted_password",                    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "developers", ["email"], :name => "index_developers_on_email", :unique => true
  add_index "developers", ["login"], :name => "index_developers_on_login", :unique => true
  add_index "developers", ["reset_password_token"], :name => "index_developers_on_reset_password_token", :unique => true

  create_table "games", :force => true do |t|
    t.string   "net",                            :null => false
    t.string   "net_id",                         :null => false
    t.string   "type"
    t.string   "slug"
    t.string   "title"
    t.text     "description"
    t.string   "driving"
    t.integer  "priority",     :default => 0
    t.text     "body"
    t.integer  "width",        :default => 0
    t.integer  "height",       :default => 0
    t.string   "image"
    t.string   "tags"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "enabled",      :default => true
    t.integer  "category_id",                    :null => false
    t.integer  "votes",        :default => 0
    t.integer  "votings",      :default => 0
    t.integer  "usage",        :default => 0
    t.string   "options"
    t.text     "net_data"
    t.integer  "developer_id"
  end

  add_index "games", ["net", "net_id"], :name => "index_games_on_net_and_net_id", :unique => true

  create_table "minecraft_users", :force => true do |t|
    t.string   "login",                            :null => false
    t.string   "password"
    t.string   "session"
    t.datetime "session_start"
    t.string   "server"
    t.boolean  "premium",       :default => false
    t.integer  "money",         :default => 0
    t.integer  "permissions",   :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "minecraft_users", ["login"], :name => "index_minecraft_users_on_login", :unique => true

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "settings", :force => true do |t|
    t.string "key",   :null => false
    t.string "value"
  end

  add_index "settings", ["key"], :name => "index_settings_on_key", :unique => true

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

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
