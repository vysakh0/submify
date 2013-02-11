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

ActiveRecord::Schema.define(:version => 20130128101524) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id",          :limit => 8
    t.integer  "commentable_id",   :limit => 8
    t.string   "commentable_type"
    t.integer  "score",            :limit => 8
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "votes_count",                   :default => 0
    t.integer  "comments_count",                :default => 0
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["score"], :name => "index_comments_on_score"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "downvotes", :force => true do |t|
    t.integer  "user_id",      :limit => 8
    t.integer  "votable_id",   :limit => 8
    t.string   "votable_type"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "downvotes", ["user_id", "votable_id", "votable_type"], :name => "index_downvotes_on_user_id_and_votable_id_and_votable_type", :unique => true
  add_index "downvotes", ["user_id"], :name => "index_downvotes_on_user_id"
  add_index "downvotes", ["votable_id", "votable_type"], :name => "index_downvotes_on_votable_id_and_votable_type"
  add_index "downvotes", ["votable_id"], :name => "index_downvotes_on_votable_id"

  create_table "flags", :force => true do |t|
    t.integer  "user_id",        :limit => 8
    t.integer  "flaggable_id",   :limit => 8
    t.string   "flaggable_type"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "flags", ["flaggable_id", "flaggable_type"], :name => "index_flags_on_flaggable_id_and_flaggable_type"
  add_index "flags", ["flaggable_id"], :name => "index_flags_on_flaggable_id"
  add_index "flags", ["user_id", "flaggable_id", "flaggable_type"], :name => "index_flags_on_user_id_and_flaggable_id_and_flaggable_type", :unique => true
  add_index "flags", ["user_id"], :name => "index_flags_on_user_id"

  create_table "link_users", :force => true do |t|
    t.integer  "link_id",     :limit => 8
    t.integer  "user_id",     :limit => 8
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "topic_id",    :limit => 8
    t.integer  "score",       :limit => 8
    t.integer  "votes_count",              :default => 0
  end

  add_index "link_users", ["link_id", "topic_id"], :name => "index_link_users_on_link_id_and_topic_id", :unique => true
  add_index "link_users", ["link_id"], :name => "index_link_users_on_link_id"
  add_index "link_users", ["score"], :name => "index_link_users_on_score"
  add_index "link_users", ["topic_id"], :name => "index_link_users_on_topic_id"
  add_index "link_users", ["user_id"], :name => "index_link_users_on_user_id"

  create_table "links", :force => true do |t|
    t.string   "url_link"
    t.string   "url_heading"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "picture"
    t.integer  "comments_count", :default => 0
    t.text     "description"
  end

  add_index "links", ["url_link"], :name => "index_links_on_url_link", :unique => true

  create_table "notifications", :force => true do |t|
    t.integer  "user_id",         :limit => 8
    t.integer  "notifiable_id",   :limit => 8
    t.string   "notifiable_type"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "parent_id",       :limit => 8
    t.string   "parent_type"
  end

  add_index "notifications", ["notifiable_id"], :name => "index_notifications_on_notifiable_id"
  add_index "notifications", ["notifiable_type", "parent_id", "parent_type", "user_id"], :name => "notification_index", :unique => true
  add_index "notifications", ["parent_id"], :name => "index_notifications_on_parent_id"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id", :limit => 8
    t.integer  "followed_id", :limit => 8
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "topic_user_relationships", :force => true do |t|
    t.integer  "user_id",    :limit => 8
    t.integer  "topic_id",   :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "topic_user_relationships", ["topic_id"], :name => "index_topic_user_relationships_on_topic_id"
  add_index "topic_user_relationships", ["user_id", "topic_id"], :name => "index_topic_user_relationships_on_user_id_and_topic_id", :unique => true
  add_index "topic_user_relationships", ["user_id"], :name => "index_topic_user_relationships_on_user_id"

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "verify",              :default => false
  end

  add_index "topics", ["name"], :name => "index_topics_on_name", :unique => true
  add_index "topics", ["slug"], :name => "index_topics_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.string   "slug"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "username"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "description"
    t.integer  "comments_count",         :default => 0
    t.integer  "link_users_count",       :default => 0
    t.integer  "relationships_count",    :default => 0
    t.integer  "notifications_count",    :default => 0
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "verify",                 :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id",      :limit => 8
    t.integer  "votable_id",   :limit => 8
    t.string   "votable_type"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "votes", ["user_id", "votable_id", "votable_type"], :name => "index_votes_on_user_id_and_votable_id_and_votable_type", :unique => true
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["votable_id"], :name => "index_votes_on_votable_id"

end
