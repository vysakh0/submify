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

ActiveRecord::Schema.define(:version => 20121021114311) do

  create_table "links", :force => true do |t|
    t.string   "url_link"
    t.string   "url_heading"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "links", ["created_at"], :name => "index_links_on_created_at"

  create_table "links_users", :id => false, :force => true do |t|
    t.integer "link_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "links_users", ["link_id", "user_id"], :name => "index_links_users_on_link_id_and_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "users_links", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "link_id", :null => false
  end

  add_index "users_links", ["user_id", "link_id"], :name => "index_users_links_on_user_id_and_link_id"

end
