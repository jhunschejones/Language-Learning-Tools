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

ActiveRecord::Schema[7.0].define(version: 0) do
  create_table "cards", force: :cascade do |t|
    t.integer "nid", null: false
    t.integer "did", null: false
    t.integer "ord", null: false
    t.integer "mod", null: false
    t.integer "usn", null: false
    t.integer "type", null: false
    t.integer "queue", null: false
    t.integer "due", null: false
    t.integer "ivl", null: false
    t.integer "factor", null: false
    t.integer "reps", null: false
    t.integer "lapses", null: false
    t.integer "left", null: false
    t.integer "odue", null: false
    t.integer "odid", null: false
    t.integer "flags", null: false
    t.text "data", null: false
    t.index ["did", "queue", "due"], name: "ix_cards_sched"
    t.index ["nid"], name: "ix_cards_nid"
    t.index ["odid"], name: "idx_cards_odid", where: "odid != 0"
    t.index ["usn"], name: "ix_cards_usn"
  end

  create_table "col", force: :cascade do |t|
    t.integer "crt", null: false
    t.integer "mod", null: false
    t.integer "scm", null: false
    t.integer "ver", null: false
    t.integer "dty", null: false
    t.integer "usn", null: false
    t.integer "ls", null: false
    t.text "conf", null: false
    t.text "models", null: false
    t.text "decks", null: false
    t.text "dconf", null: false
    t.text "tags", null: false
  end

  create_table "config", primary_key: "KEY", id: :text, force: :cascade do |t|
    t.integer "usn", null: false
    t.integer "mtime_secs", null: false
    t.binary "val", null: false
  end

  create_table "deck_config", force: :cascade do |t|
    t.text "name", null: false
    t.integer "mtime_secs", null: false
    t.integer "usn", null: false
    t.binary "config", null: false
  end

  create_table "decks", force: :cascade do |t|
    t.text "name", null: false
    t.integer "mtime_secs", null: false
    t.integer "usn", null: false
    t.binary "common", null: false
    t.binary "kind", null: false
    t.index ["name"], name: "idx_decks_name", unique: true
  end

  create_table "fields", primary_key: ["ntid", "ord"], force: :cascade do |t|
    t.integer "ntid", null: false
    t.integer "ord", null: false
    t.text "name", null: false
    t.binary "config", null: false
    t.index ["name", "ntid"], name: "idx_fields_name_ntid", unique: true
  end

  create_table "graves", primary_key: ["oid", "type"], force: :cascade do |t|
    t.integer "oid", null: false
    t.integer "type", null: false
    t.integer "usn", null: false
    t.index ["usn"], name: "idx_graves_pending"
  end

  create_table "notes", force: :cascade do |t|
    t.text "guid", null: false
    t.integer "mid", null: false
    t.integer "mod", null: false
    t.integer "usn", null: false
    t.text "tags", null: false
    t.text "flds", null: false
    t.integer "sfld", null: false
    t.integer "csum", null: false
    t.integer "flags", null: false
    t.text "data", null: false
    t.index ["csum"], name: "ix_notes_csum"
    t.index ["mid"], name: "idx_notes_mid"
    t.index ["usn"], name: "ix_notes_usn"
  end

  create_table "notetypes", force: :cascade do |t|
    t.text "name", null: false
    t.integer "mtime_secs", null: false
    t.integer "usn", null: false
    t.binary "config", null: false
    t.index ["name"], name: "idx_notetypes_name", unique: true
    t.index ["usn"], name: "idx_notetypes_usn"
  end

  create_table "revlog", force: :cascade do |t|
    t.integer "cid", null: false
    t.integer "usn", null: false
    t.integer "ease", null: false
    t.integer "ivl", null: false
    t.integer "lastIvl", null: false
    t.integer "factor", null: false
    t.integer "time", null: false
    t.integer "type", null: false
    t.index ["cid"], name: "ix_revlog_cid"
    t.index ["usn"], name: "ix_revlog_usn"
  end

# Could not dump table "sqlite_stat1" because of following StandardError
#   Unknown type '' for column 'tbl'

# Could not dump table "sqlite_stat4" because of following StandardError
#   Unknown type '' for column 'tbl'

  create_table "tags", primary_key: "tag", id: :text, force: :cascade do |t|
    t.integer "usn", null: false
    t.boolean "collapsed", null: false
    t.binary "config"
  end

  create_table "templates", primary_key: ["ntid", "ord"], force: :cascade do |t|
    t.integer "ntid", null: false
    t.integer "ord", null: false
    t.text "name", null: false
    t.integer "mtime_secs", null: false
    t.integer "usn", null: false
    t.binary "config", null: false
    t.index ["name", "ntid"], name: "idx_templates_name_ntid", unique: true
    t.index ["usn"], name: "idx_templates_usn"
  end

end
