# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 8) do

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "house"
    t.string "bloodStatus"
  end

  create_table "games", force: :cascade do |t|
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "spells", force: :cascade do |t|
    t.string "spell"
    t.string "effect"
  end

  create_table "user_characters", force: :cascade do |t|
    t.integer "user_id"
    t.integer "character_id"
    t.index ["character_id"], name: "index_user_characters_on_character_id"
    t.index ["user_id"], name: "index_user_characters_on_user_id"
  end

  create_table "user_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.index ["item_id"], name: "index_user_items_on_item_id"
    t.index ["user_id"], name: "index_user_items_on_user_id"
  end

  create_table "user_spells", force: :cascade do |t|
    t.integer "user_id"
    t.integer "spell_id"
    t.index ["spell_id"], name: "index_user_spells_on_spell_id"
    t.index ["user_id"], name: "index_user_spells_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.index ["game_id"], name: "index_users_on_game_id"
  end

end
