# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_08_23_130411) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.text "question", null: false
    t.text "answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["name"], name: "index_decks_on_name", unique: true
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "study_results", force: :cascade do |t|
    t.bigint "study_session_id", null: false
    t.bigint "card_id", null: false
    t.boolean "correct", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_study_results_on_card_id"
    t.index ["study_session_id", "card_id"], name: "index_study_results_on_study_session_id_and_card_id", unique: true
    t.index ["study_session_id"], name: "index_study_results_on_study_session_id"
  end

  create_table "study_sessions", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "current_index", default: 0, null: false
    t.integer "card_order", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_index"], name: "index_study_sessions_on_current_index"
    t.index ["deck_id"], name: "index_study_sessions_on_deck_id"
    t.index ["status"], name: "index_study_sessions_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cards", "decks"
  add_foreign_key "decks", "users"
  add_foreign_key "study_results", "cards", on_delete: :cascade
  add_foreign_key "study_results", "study_sessions", on_delete: :cascade
  add_foreign_key "study_sessions", "decks", on_delete: :cascade
end
