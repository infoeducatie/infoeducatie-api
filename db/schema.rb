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

ActiveRecord::Schema.define(version: 20140714061218) do

  create_table "alumnis", force: true do |t|
    t.string   "description"
    t.string   "picture"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "editions", force: true do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer  "cardinal"
    t.string   "motto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "editions", ["cardinal"], name: "index_editions_on_cardinal", unique: true

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "edition_id"
    t.boolean  "is_pinned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "edited_by"
    t.integer  "version"
    t.integer  "edition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "technologies"
    t.string   "coordinators"
    t.string   "url"
    t.boolean  "is_approved"
    t.integer  "edition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", force: true do |t|
    t.integer  "edition_id"
    t.string   "name"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "talks", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "scheduled_at"
    t.integer  "duration"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end
