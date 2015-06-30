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

ActiveRecord::Schema.define(version: 20150630064923) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colaborators", force: :cascade do |t|
    t.integer  "contestant_id"
    t.integer  "project_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "contestants", force: :cascade do |t|
    t.string   "address"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "zip_code"
    t.string   "cnp"
    t.integer  "sex"
    t.string   "id_card_type"
    t.string   "id_card_number"
    t.string   "phone_number"
    t.string   "school_name"
    t.string   "grade"
    t.string   "school_county"
    t.string   "school_city"
    t.string   "school_country"
    t.date     "date_of_birth"
    t.string   "mentoring_teacher_first_name"
    t.string   "mentoring_teacher_last_name"
    t.boolean  "official"
    t.integer  "user_id"
    t.integer  "edition_id"
    t.integer  "accompanying_teacher_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "present_in_camp",              default: false
    t.boolean  "paying_camp_accommodation",    default: false
  end

  create_table "editions", force: :cascade do |t|
    t.integer  "year"
    t.string   "name"
    t.date     "camp_start_date"
    t.date     "camp_end_date"
    t.string   "motto"
    t.datetime "registration_start_date"
    t.datetime "registration_end_date"
    t.date     "travel_data_deadline"
    t.boolean  "published"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "is_current",              default: false
    t.boolean  "current",                 default: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "technical_description"
    t.text     "system_requirements"
    t.string   "source_url"
    t.string   "homepage"
    t.boolean  "approved"
    t.float    "final_score"
    t.float    "extra_score"
    t.text     "notes"
    t.integer  "category_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "rights", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rights", ["role_id"], name: "index_rights_on_role_id"
  add_index "rights", ["user_id"], name: "index_rights_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.integer  "discourse_id"
    t.string   "access_token"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
