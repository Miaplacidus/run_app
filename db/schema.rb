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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140728043118) do

  create_table "challenges", force: true do |t|
    t.string   "name"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "post_id"
    t.string   "state"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "circle_users", force: true do |t|
    t.integer  "circle_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "circles", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "max_members"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "description"
    t.integer  "level"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commitments", force: true do |t|
    t.float   "amount"
    t.boolean "fulfilled"
    t.integer "post_id"
    t.integer "user_id"
  end

  add_index "commitments", ["post_id"], name: "index_commitments_on_post_id"
  add_index "commitments", ["user_id"], name: "index_commitments_on_user_id"

  create_table "join_requests", force: true do |t|
    t.integer  "circle_id"
    t.integer  "user_id"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "join_requests", ["circle_id"], name: "index_join_requests_on_circle_id"
  add_index "join_requests", ["user_id"], name: "index_join_requests_on_user_id"

  create_table "post_users", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_users", ["post_id"], name: "index_post_users_on_post_id"
  add_index "post_users", ["user_id"], name: "index_post_users_on_user_id"

  create_table "posts", force: true do |t|
    t.integer  "circle_id"
    t.integer  "user_id"
    t.datetime "time"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "pace"
    t.text     "notes"
    t.boolean  "complete"
    t.float    "min_amt"
    t.integer  "age_pref"
    t.integer  "gender_pref"
    t.integer  "max_runners"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["circle_id"], name: "index_posts_on_circle_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.integer  "gender"
    t.string   "email"
    t.string   "bday"
    t.integer  "rating"
    t.integer  "level"
    t.string   "fbid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "img_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wallets", force: true do |t|
    t.integer  "user_id"
    t.float    "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
