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

  create_table "games", force: :cascade do |t|
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "name"
  end

  create_table "spells", force: :cascade do |t|
    t.string "spell"
    t.string "effect"
  end

  create_table "useritems", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.index ["item_id"], name: "index_useritems_on_item_id"
    t.index ["user_id"], name: "index_useritems_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.index ["game_id"], name: "index_users_on_game_id"
  end

  create_table "userscenarios", force: :cascade do |t|
    t.integer "user_id"
    t.integer "scenario_id"
    t.index ["scenario_id"], name: "index_userscenarios_on_scenario_id"
    t.index ["user_id"], name: "index_userscenarios_on_user_id"
  end

  create_table "userspells", force: :cascade do |t|
    t.integer "user_id"
    t.integer "spell_id"
    t.index ["spell_id"], name: "index_userspells_on_spell_id"
    t.index ["user_id"], name: "index_userspells_on_user_id"
  end

end
