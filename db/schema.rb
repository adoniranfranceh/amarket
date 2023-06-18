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

ActiveRecord::Schema.define(version: 2023_06_18_151424) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "descryption"
    t.integer "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_categories_on_admin_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.integer "phone"
    t.string "email"
    t.string "city"
    t.string "neighborhood"
    t.string "andress"
    t.string "house_number"
    t.integer "cpf"
    t.integer "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_customers_on_admin_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "descryption"
    t.integer "category_id"
    t.string "brand"
    t.float "purchase_price"
    t.float "sale_price"
    t.integer "quantity"
    t.integer "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_products_on_admin_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  add_foreign_key "categories", "admins"
  add_foreign_key "customers", "admins"
  add_foreign_key "products", "admins"
  add_foreign_key "products", "categories"
end
