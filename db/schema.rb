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

ActiveRecord::Schema[7.0].define(version: 2023_12_24_060817) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disbursements", force: :cascade do |t|
    t.bigint "merchant_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "commission", precision: 10, scale: 2, null: false
    t.string "reference", null: false
    t.datetime "disbursed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
    t.index ["reference"], name: "index_disbursements_on_reference", unique: true
  end

  create_table "merchants", force: :cascade do |t|
    t.string "reference", null: false
    t.string "email", null: false
    t.date "live_on", null: false
    t.string "disbursement_frequency", null: false
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_merchants_on_email", unique: true
  end

  create_table "monthly_fee_records", force: :cascade do |t|
    t.bigint "merchant_id", null: false
    t.decimal "fee", precision: 10, scale: 2, null: false
    t.date "record_month_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_monthly_fee_records_on_merchant_id"
  end

  add_foreign_key "disbursements", "merchants"
  add_foreign_key "monthly_fee_records", "merchants"
end
