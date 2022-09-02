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

ActiveRecord::Schema.define(version: 2022_09_02_014942) do

  create_table "account_exchanges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date"
    t.integer "value"
    t.date "pay_date"
    t.bigint "card_id"
    t.bigint "source_id"
    t.bigint "to_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_account_exchanges_on_card_id"
    t.index ["source_id"], name: "index_account_exchanges_on_source_id"
    t.index ["to_id"], name: "index_account_exchanges_on_to_id"
    t.index ["user_id"], name: "index_account_exchanges_on_user_id"
  end

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "pay_date"
    t.integer "month_date"
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_cards_on_account_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date"
    t.date "pay_date"
    t.string "memo"
    t.integer "value"
    t.boolean "iae", default: false
    t.bigint "user_id", null: false
    t.bigint "genre_id"
    t.bigint "account_id"
    t.bigint "card_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_events_on_account_id"
    t.index ["card_id"], name: "index_events_on_card_id"
    t.index ["genre_id"], name: "index_events_on_genre_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "fund_user_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "card_id"
    t.date "pay_date"
    t.boolean "buy_or_sell", default: true
    t.integer "value"
    t.integer "commission"
    t.bigint "fund_user_id", null: false
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_fund_user_histories_on_account_id"
    t.index ["card_id"], name: "index_fund_user_histories_on_card_id"
    t.index ["fund_user_id"], name: "index_fund_user_histories_on_fund_user_id"
  end

  create_table "fund_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "fund_id", null: false
    t.decimal "average_buy_value", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fund_id"], name: "index_fund_users_on_fund_id"
    t.index ["user_id"], name: "index_fund_users_on_user_id"
  end

  create_table "funds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "value"
    t.string "name"
    t.date "update_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "string_id"
  end

  create_table "genres", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "iae", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_genres_on_user_id"
  end

  create_table "shortcuts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "token"
    t.boolean "iae"
    t.bigint "card_id"
    t.bigint "account_id", null: false
    t.bigint "genre_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_shortcuts_on_account_id"
    t.index ["card_id"], name: "index_shortcuts_on_card_id"
    t.index ["genre_id"], name: "index_shortcuts_on_genre_id"
    t.index ["user_id"], name: "index_shortcuts_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.text "tokens"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "account_exchanges", "accounts", column: "source_id"
  add_foreign_key "account_exchanges", "accounts", column: "to_id"
  add_foreign_key "account_exchanges", "users"
  add_foreign_key "accounts", "users"
  add_foreign_key "cards", "accounts"
  add_foreign_key "cards", "users"
  add_foreign_key "events", "users"
  add_foreign_key "fund_user_histories", "fund_users"
  add_foreign_key "fund_users", "funds"
  add_foreign_key "fund_users", "users"
  add_foreign_key "genres", "users"
  add_foreign_key "shortcuts", "accounts"
  add_foreign_key "shortcuts", "genres"
  add_foreign_key "shortcuts", "users"
end
