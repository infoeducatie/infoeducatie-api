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

ActiveRecord::Schema[8.1].define(version: 2026_08_01_200000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alumni", force: :cascade do |t|
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description_en"
  end

  add_index "alumni", ["user_id"], name: "index_alumni_on_user_id", unique: true, using: :btree

  create_table "api_credentials", force: :cascade do |t|
    t.string   "name",                                      null: false
    t.text     "description"
    t.string   "token_identifier",                          null: false
    t.string   "secret_digest",                             null: false
    t.jsonb    "scopes",                    default: [],    null: false
    t.datetime "expires_at",                                null: false
    t.datetime "revoked_at"
    t.integer  "created_by_id"
    t.integer  "revoked_by_id"
    t.datetime "last_used_at"
    t.string   "last_used_ip",              limit: 45
    t.bigint   "use_count",                 default: 0,     null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "api_credentials", ["created_by_id"], name: "index_api_credentials_on_created_by_id", using: :btree
  add_index "api_credentials", ["revoked_at", "expires_at"], name: "index_api_credentials_on_revoked_at_and_expires_at", using: :btree
  add_index "api_credentials", ["revoked_by_id"], name: "index_api_credentials_on_revoked_by_id", using: :btree
  add_index "api_credentials", ["token_identifier"], name: "index_api_credentials_on_token_identifier", unique: true, using: :btree

  create_table "attendances", force: :cascade do |t|
    t.integer  "alumnus_id"
    t.integer  "edition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string   "slug",                              null: false
    t.string   "title",                             null: false
    t.string   "title_en"
    t.text     "excerpt",                           null: false
    t.text     "excerpt_en"
    t.text     "body",                              null: false
    t.text     "body_en"
    t.string   "author_name",                       null: false
    t.string   "category"
    t.string   "category_en"
    t.datetime "published_at",                      null: false
    t.boolean  "active",        default: true,      null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "blog_posts", ["active", "published_at"], name: "index_blog_posts_on_active_and_published_at", using: :btree
  add_index "blog_posts", ["slug"], name: "index_blog_posts_on_slug", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "content_pages", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.string   "title",                     null: false
    t.string   "title_en"
    t.text     "body",                      null: false
    t.text     "body_en"
    t.string   "document"
    t.string   "document_en"
    t.boolean  "active",    default: true,  null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "content_pages", ["active", "slug"], name: "index_content_pages_on_active_and_slug", using: :btree
  add_index "content_pages", ["slug"], name: "index_content_pages_on_slug", unique: true, using: :btree

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
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "present_in_camp",              default: false
    t.boolean  "paying_camp_accommodation",    default: false
  end

  add_index "contestants", ["user_id", "edition_id"], name: "index_contestants_on_user_id_and_edition_id", unique: true, using: :btree

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
    t.boolean  "current",                 default: false
    t.string   "projects_forum_category"
    t.integer  "talks_count"
    t.string   "talks_forum_category"
    t.boolean  "show_results"
  end

  create_table "judging_criteria", force: :cascade do |t|
    t.string   "title",                     null: false
    t.string   "title_en",                  null: false
    t.string   "document",                  null: false
    t.integer  "position",  default: 0,     null: false
    t.boolean  "active",    default: true,  null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "judging_criteria", ["active", "position"], name: "index_judging_criteria_on_active_and_position", using: :btree
  add_index "judging_criteria", ["position"], name: "index_judging_criteria_on_position", using: :btree
  add_index "judging_criteria", ["title"], name: "index_judging_criteria_on_title", unique: true, using: :btree

  create_table "jury_categories", force: :cascade do |t|
    t.string   "title",                     null: false
    t.string   "title_en",                  null: false
    t.string   "icon"
    t.integer  "position",  default: 0,     null: false
    t.boolean  "active",    default: true,  null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "jury_categories", ["position"], name: "index_jury_categories_on_position", using: :btree
  add_index "jury_categories", ["title"], name: "index_jury_categories_on_title", unique: true, using: :btree

  create_table "jury_members", force: :cascade do |t|
    t.string   "title"
    t.string   "title_en"
    t.string   "name",                                      null: false
    t.string   "photo",                                     null: false
    t.string   "occupation",                                null: false
    t.string   "occupation_en"
    t.integer  "position",         default: 0,              null: false
    t.boolean  "active",           default: true,           null: false
    t.bigint   "jury_category_id",                          null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "jury_members", ["jury_category_id", "position"], name: "index_jury_members_on_jury_category_id_and_position", using: :btree
  add_index "jury_members", ["jury_category_id"], name: "index_jury_members_on_jury_category_id", using: :btree

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "pinned",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "edition_id"
    t.text     "short"
    t.string   "title_en"
    t.text     "body_en"
  end

  create_table "photo_albums", force: :cascade do |t|
    t.string   "title",                      null: false
    t.string   "title_en"
    t.string   "external_url",               null: false
    t.string   "cover_image",                null: false
    t.integer  "position",    default: 0,    null: false
    t.boolean  "active",      default: true, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "photo_albums", ["active", "position"], name: "index_photo_albums_on_active_and_position", using: :btree
  add_index "photo_albums", ["title"], name: "index_photo_albums_on_title", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "technical_description"
    t.text     "system_requirements"
    t.string   "source_url"
    t.string   "homepage"
    t.float    "extra_score",           default: 0.0,   null: false
    t.integer  "category_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "finished",              default: false
    t.integer  "topic_id"
    t.boolean  "open_source"
    t.string   "closed_source_reason"
    t.string   "github_username"
    t.integer  "status",                default: 0,     null: false
    t.float    "score",                 default: 0.0,   null: false
    t.float    "total_score",           default: 0.0,   null: false
    t.string   "prize"
    t.integer  "comments_count",        default: 0,     null: false
    t.integer  "edition_id",                            null: false
  end

  add_index "projects", ["edition_id"], name: "index_projects_on_edition_id", using: :btree

  create_table "rights", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rights", ["role_id"], name: "index_rights_on_role_id", using: :btree
  add_index "rights", ["user_id"], name: "index_rights_on_user_id", using: :btree

  create_table "robotics_competitions", force: :cascade do |t|
    t.string   "name",                                     null: false
    t.string   "slug",                                     null: false
    t.datetime "starts_at",                                null: false
    t.integer  "duration_seconds",         default: 72000, null: false
    t.integer  "team_allocation_seconds",  default: 10800, null: false
    t.integer  "turn_duration_seconds",    default: 600,   null: false
    t.integer  "claim_window_seconds",     default: 60,    null: false
    t.integer  "turnover_seconds",         default: 60,    null: false
    t.bigint   "queue_sequence",           default: 0,     null: false
    t.bigint   "turn_sequence",            default: 0,     null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "robotics_competitions", ["slug"], name: "index_robotics_competitions_on_slug", unique: true, using: :btree
  add_check_constraint "robotics_competitions", "duration_seconds > 0", name: "robotics_competitions_duration_positive"
  add_check_constraint "robotics_competitions", "team_allocation_seconds > 0", name: "robotics_competitions_allocation_positive"
  add_check_constraint "robotics_competitions", "turn_duration_seconds > 0 AND turn_duration_seconds <= duration_seconds", name: "robotics_competitions_turn_duration_valid"
  add_check_constraint "robotics_competitions", "claim_window_seconds > 0", name: "robotics_competitions_claim_window_positive"
  add_check_constraint "robotics_competitions", "turnover_seconds >= 0", name: "robotics_competitions_turnover_nonnegative"

  create_table "robotics_teams", force: :cascade do |t|
    t.bigint   "robotics_competition_id",                  null: false
    t.string   "name",                                     null: false
    t.integer  "position",                                 null: false
    t.string   "pin_digest",                               null: false
    t.string   "pin_fingerprint",                          null: false
    t.integer  "authentication_version", default: 0,       null: false
    t.boolean  "enabled",                default: true,    null: false
    t.boolean  "ready",                  default: false,   null: false
    t.datetime "cooldown_until"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "robotics_teams", ["robotics_competition_id"], name: "index_robotics_teams_on_robotics_competition_id", using: :btree
  add_index "robotics_teams", ["robotics_competition_id", "name"], name: "index_robotics_teams_on_robotics_competition_id_and_name", unique: true, using: :btree
  add_index "robotics_teams", ["robotics_competition_id", "position"], name: "index_robotics_teams_on_robotics_competition_id_and_position", unique: true, using: :btree
  add_index "robotics_teams", ["robotics_competition_id", "pin_fingerprint"], name: "index_robotics_teams_on_competition_and_pin", unique: true, using: :btree
  add_check_constraint "robotics_teams", "position > 0", name: "robotics_teams_position_positive"

  create_table "robotics_queue_entries", force: :cascade do |t|
    t.bigint   "robotics_competition_id", null: false
    t.bigint   "robotics_team_id",        null: false
    t.bigint   "sequence_number",         null: false
    t.datetime "requested_at",            null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "robotics_queue_entries", ["robotics_competition_id"], name: "index_robotics_queue_entries_on_robotics_competition_id", using: :btree
  add_index "robotics_queue_entries", ["robotics_team_id"], name: "index_robotics_queue_entries_on_robotics_team_id", unique: true, using: :btree
  add_index "robotics_queue_entries", ["robotics_competition_id", "sequence_number"], name: "index_robotics_queue_on_competition_and_sequence", unique: true, using: :btree

  create_table "robotics_turns", force: :cascade do |t|
    t.bigint   "robotics_competition_id", null: false
    t.bigint   "robotics_team_id",        null: false
    t.bigint   "sequence_number",         null: false
    t.string   "state",                   null: false
    t.datetime "offered_at",              null: false
    t.datetime "offer_expires_at",        null: false
    t.datetime "started_at"
    t.datetime "session_ends_at"
    t.datetime "ended_at"
    t.datetime "turnover_ends_at"
    t.integer  "reserved_seconds"
    t.integer  "charged_seconds"
    t.string   "stop_reason"
    t.integer  "stopped_by_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "robotics_turns", ["robotics_competition_id"], name: "index_robotics_turns_on_robotics_competition_id", using: :btree
  add_index "robotics_turns", ["robotics_team_id"], name: "index_robotics_turns_on_robotics_team_id", using: :btree
  add_index "robotics_turns", ["stopped_by_id"], name: "index_robotics_turns_on_stopped_by_id", using: :btree
  add_index "robotics_turns", ["robotics_competition_id", "sequence_number"], name: "index_robotics_turns_on_competition_and_sequence", unique: true, using: :btree
  add_index "robotics_turns", ["robotics_competition_id"], name: "index_robotics_turns_one_live_lease", unique: true, where: "state IN ('offered', 'active', 'turnover')", using: :btree
  add_check_constraint "robotics_turns", "state IN ('offered', 'active', 'turnover', 'completed', 'passed', 'expired', 'withdrawn')", name: "robotics_turns_state_valid"
  add_check_constraint "robotics_turns", "offer_expires_at >= offered_at", name: "robotics_turns_offer_window_valid"
  add_check_constraint "robotics_turns", "reserved_seconds IS NULL OR reserved_seconds > 0", name: "robotics_turns_reserved_positive"
  add_check_constraint "robotics_turns", "charged_seconds IS NULL OR charged_seconds >= 0", name: "robotics_turns_charged_nonnegative"

  create_table "robotics_time_entries", force: :cascade do |t|
    t.bigint   "robotics_competition_id", null: false
    t.bigint   "robotics_team_id",        null: false
    t.bigint   "robotics_turn_id"
    t.string   "kind",                    null: false
    t.integer  "amount_seconds",          null: false
    t.text     "reason",                  null: false
    t.integer  "actor_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "robotics_time_entries", ["robotics_competition_id"], name: "index_robotics_time_entries_on_robotics_competition_id", using: :btree
  add_index "robotics_time_entries", ["robotics_team_id"], name: "index_robotics_time_entries_on_robotics_team_id", using: :btree
  add_index "robotics_time_entries", ["robotics_turn_id"], name: "index_robotics_time_entries_on_robotics_turn_id", unique: true, where: "robotics_turn_id IS NOT NULL", using: :btree
  add_index "robotics_time_entries", ["actor_id"], name: "index_robotics_time_entries_on_actor_id", using: :btree
  add_index "robotics_time_entries", ["robotics_team_id"], name: "index_robotics_time_entries_one_initial_grant", unique: true, where: "kind = 'initial_grant'", using: :btree
  add_index "robotics_time_entries", ["robotics_team_id", "created_at"], name: "index_robotics_time_entries_on_robotics_team_id_and_created_at", using: :btree
  add_check_constraint "robotics_time_entries", "kind IN ('initial_grant', 'session_usage', 'admin_adjustment')", name: "robotics_time_entries_kind_valid"
  add_check_constraint "robotics_time_entries", "amount_seconds <> 0", name: "robotics_time_entries_amount_nonzero"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "screenshots", force: :cascade do |t|
    t.string   "screenshot"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sponsor_tiers", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "name_en"
    t.integer  "position",   default: 0,  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sponsor_tiers", ["name"], name: "index_sponsor_tiers_on_name", unique: true, using: :btree
  add_index "sponsor_tiers", ["position"], name: "index_sponsor_tiers_on_position", using: :btree

  create_table "sponsors", force: :cascade do |t|
    t.string   "title",                              null: false
    t.string   "image",                              null: false
    t.string   "website_url"
    t.integer  "position",          default: 0,      null: false
    t.boolean  "active",            default: true,   null: false
    t.bigint   "sponsor_tier_id",                    null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "sponsors", ["sponsor_tier_id", "position"], name: "index_sponsors_on_sponsor_tier_id_and_position", using: :btree
  add_index "sponsors", ["sponsor_tier_id"], name: "index_sponsors_on_sponsor_tier_id", using: :btree

  create_table "talk_users", force: :cascade do |t|
    t.integer  "talk_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "talk_users", ["talk_id"], name: "index_talk_users_on_talk_id", using: :btree
  add_index "talk_users", ["user_id"], name: "index_talk_users_on_user_id", using: :btree

  create_table "talks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "edition_id"
    t.integer  "topic_id"
    t.integer  "comments_count", default: 0, null: false
    t.string   "title_en"
    t.text     "description_en"
  end

  create_table "teachers", force: :cascade do |t|
    t.integer  "sex"
    t.string   "phone_number"
    t.string   "school_name"
    t.string   "school_county"
    t.string   "school_city"
    t.string   "school_country"
    t.integer  "user_id"
    t.integer  "edition_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "teachers", ["user_id", "edition_id"], name: "index_teachers_on_user_id_and_edition_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "", null: false
    t.string   "encrypted_password",       default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,  null: false
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
    t.string   "first_name",               default: "", null: false
    t.string   "last_name",                default: "", null: false
    t.integer  "discourse_id"
    t.string   "access_token"
    t.integer  "registration_step_number", default: 1
    t.string   "job"
    t.boolean  "newsletter"
    t.string   "job_en"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "api_credentials", "users", column: "created_by_id", on_delete: :nullify
  add_foreign_key "api_credentials", "users", column: "revoked_by_id", on_delete: :nullify
  add_foreign_key "jury_members", "jury_categories"
  add_foreign_key "robotics_queue_entries", "robotics_competitions", on_delete: :cascade
  add_foreign_key "robotics_queue_entries", "robotics_teams", on_delete: :cascade
  add_foreign_key "robotics_teams", "robotics_competitions", on_delete: :cascade
  add_foreign_key "robotics_time_entries", "robotics_competitions", on_delete: :cascade
  add_foreign_key "robotics_time_entries", "robotics_teams", on_delete: :restrict
  add_foreign_key "robotics_time_entries", "robotics_turns", on_delete: :restrict
  add_foreign_key "robotics_time_entries", "users", column: "actor_id", on_delete: :nullify
  add_foreign_key "robotics_turns", "robotics_competitions", on_delete: :cascade
  add_foreign_key "robotics_turns", "robotics_teams", on_delete: :restrict
  add_foreign_key "robotics_turns", "users", column: "stopped_by_id", on_delete: :nullify
  add_foreign_key "sponsors", "sponsor_tiers"
end
