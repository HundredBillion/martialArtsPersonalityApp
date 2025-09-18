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

ActiveRecord::Schema[8.0].define(version: 2025_09_17_000300) do
  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text "text", null: false
    t.integer "personality", default: 0, null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personality"], name: "index_questions_on_personality"
    t.index ["position"], name: "index_questions_on_position"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "submission_id", null: false
    t.integer "question_id", null: false
    t.integer "value", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_responses_on_question_id"
    t.index ["submission_id"], name: "index_responses_on_submission_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "ip_address"
    t.string "user_agent"
    t.string "result_primary"
    t.json "result_payload"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "responses", "questions"
  add_foreign_key "responses", "submissions"
end
