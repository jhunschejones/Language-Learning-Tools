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

ActiveRecord::Schema[7.0].define(version: 1) do
  create_table "sentences", force: :cascade do |t|
    t.string "japanese_word"
    t.text "japanese_sentence", null: false
    t.text "english_sentence", null: false
    t.bigint "pcloud_file_id", null: false
    t.string "pcloud_download_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["japanese_sentence"], name: "index_sentences_on_japanese_sentence", unique: true
    t.index ["pcloud_file_id"], name: "index_sentences_on_pcloud_file_id", unique: true
  end

end
