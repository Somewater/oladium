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

ActiveRecord::Schema.define(:version => 20130305144108) do

  create_table "categories", :force => true do |t|
    t.string "name",     :null => false
    t.string "title_ru"
    t.string "title_en"
  end

  create_table "games", :force => true do |t|
    t.string   "net",                           :null => false
    t.string   "net_id",                        :null => false
    t.string   "type"
    t.string   "slug"
    t.string   "title"
    t.text     "description"
    t.string   "driving"
    t.integer  "priority",    :default => 0
    t.text     "body"
    t.integer  "width",       :default => 0
    t.integer  "height",      :default => 0
    t.string   "image"
    t.string   "tags"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "enabled",     :default => true
    t.integer  "category_id",                   :null => false
    t.integer  "votes",       :default => 0
    t.integer  "votings",     :default => 0
    t.integer  "usage",       :default => 0
    t.string   "options"
  end

  add_index "games", ["net", "net_id"], :name => "index_games_on_net_and_net_id", :unique => true

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

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
