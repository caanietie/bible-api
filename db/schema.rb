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

ActiveRecord::Schema[7.1].define(version: 2038_12_25_111841) do
  create_table "books", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "chapter", null: false
    t.text "info_html", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_chapters_on_book_id"
    t.index ["chapter"], name: "index_chapters_on_chapter"
  end

  create_table "verses", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "chapter_id", null: false
    t.integer "verse", null: false
    t.text "info_html", null: false
    t.text "info_text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_verses_on_book_id"
    t.index ["chapter_id"], name: "index_verses_on_chapter_id"
    t.index ["verse"], name: "index_verses_on_verse"
  end

  create_table "wordlists", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word"], name: "index_wordlists_on_word"
  end

  create_table "wordlistverses", force: :cascade do |t|
    t.integer "verse_id", null: false
    t.integer "wordlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["verse_id"], name: "index_wordlistverses_on_verse_id"
    t.index ["wordlist_id"], name: "index_wordlistverses_on_wordlist_id"
  end

  add_foreign_key "chapters", "books"
  add_foreign_key "verses", "books"
  add_foreign_key "verses", "chapters"
  add_foreign_key "wordlistverses", "verses"
  add_foreign_key "wordlistverses", "wordlists"
end
