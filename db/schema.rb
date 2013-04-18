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

ActiveRecord::Schema.define(:version => 20130418073134) do

  create_table "songs", :force => true do |t|
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "audio_file_file_name"
    t.string   "audio_file_content_type"
    t.integer  "audio_file_file_size"
    t.datetime "audio_file_updated_at"
    t.integer  "user_id"
    t.string   "title"
    t.string   "artist"
    t.string   "album"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "role",                :default => "user"
    t.string   "email",                                   :null => false
    t.integer  "upload_limit",        :default => 100,    :null => false
  end

end
