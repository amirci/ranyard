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

ActiveRecord::Schema.define(:version => 20111130061700) do

  create_table "assignments", :force => true do |t|
    t.integer  "speaker_id"
    t.integer  "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.date     "start"
    t.date     "finish"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.string   "venue"
    t.string   "city"
  end

  create_table "events", :force => true do |t|
    t.datetime "start"
    t.datetime "finish"
    t.text     "custom"
    t.boolean  "main"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conference_id"
  end

  create_table "info_requests", :force => true do |t|
    t.string   "email"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conference_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "title"
    t.text     "abstract"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "planning_to_attend"
    t.integer  "conference_id"
  end

  create_table "speakers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.string   "twitter"
    t.string   "location"
    t.string   "blog"
    t.string   "picture"
    t.integer  "conference_id"
  end

  create_table "sponsors", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo_file_name"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "conference_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
