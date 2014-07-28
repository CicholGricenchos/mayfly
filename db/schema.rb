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

ActiveRecord::Schema.define(version: 6) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_comments", force: true do |t|
    t.string   "author"
    t.text     "content"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "brief"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.integer  "category_id"
    t.boolean  "visible"
  end

  create_table "categories", force: true do |t|
    t.string "name"
  end

  create_table "schema_info", id: false, force: true do |t|
    t.integer "version", default: 0, null: false
  end

  create_table "site_configs", force: true do |t|
    t.string "name"
    t.string "value"
  end

end
