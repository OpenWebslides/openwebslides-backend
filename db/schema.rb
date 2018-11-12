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

ActiveRecord::Schema.define(version: 2018_11_12_113733) do

  create_table "alerts", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "count"
    t.integer "topic_id"
    t.index ["topic_id"], name: "index_alerts_on_topic_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "annotations", force: :cascade do |t|
    t.string "type"
    t.string "content_item_id"
    t.integer "user_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "text"
    t.integer "conversation_type"
    t.integer "conversation_id"
    t.integer "state"
    t.string "title"
    t.index ["conversation_id"], name: "index_annotations_on_conversation_id"
    t.index ["topic_id"], name: "index_annotations_on_topic_id"
    t.index ["user_id"], name: "index_annotations_on_user_id"
  end

  create_table "assets", force: :cascade do |t|
    t.string "filename"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename", "topic_id"], name: "index_assets_on_filename_and_topic_id", unique: true
    t.index ["topic_id"], name: "index_assets_on_topic_id"
  end

  create_table "feed_items", force: :cascade do |t|
    t.integer "event_type"
    t.integer "user_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_feed_items_on_topic_id"
    t.index ["user_id"], name: "index_feed_items_on_user_id"
  end

  create_table "grants", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "topic_id", null: false
    t.index ["topic_id", "user_id"], name: "index_grants_on_topic_id_and_user_id", unique: true
    t.index ["topic_id"], name: "index_grants_on_topic_id"
    t.index ["user_id", "topic_id"], name: "index_grants_on_user_id_and_topic_id", unique: true
    t.index ["user_id"], name: "index_grants_on_user_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_identities_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "pull_requests", force: :cascade do |t|
    t.string "message", default: "", null: false
    t.string "feedback"
    t.integer "state"
    t.integer "user_id"
    t.integer "source_id"
    t.integer "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_pull_requests_on_source_id"
    t.index ["target_id"], name: "index_pull_requests_on_target_id"
    t.index ["user_id"], name: "index_pull_requests_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "annotation_id", null: false
    t.index ["annotation_id", "user_id"], name: "index_ratings_on_annotation_id_and_user_id", unique: true
    t.index ["annotation_id"], name: "index_ratings_on_annotation_id"
    t.index ["user_id", "annotation_id"], name: "index_ratings_on_user_id_and_annotation_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title"
    t.integer "state", default: 0
    t.string "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "root_content_item_id"
    t.integer "upstream_id"
    t.index ["upstream_id"], name: "index_topics_on_upstream_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "token_version", default: 1, null: false
    t.boolean "tos_accepted"
    t.string "locale", default: "", null: false
    t.string "name", default: "", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
