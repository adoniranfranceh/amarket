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

ActiveRecord::Schema.define(version: 2023_08_18_185230) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "cash_registers", force: :cascade do |t|
    t.integer "cash_id", null: false
    t.float "initial_value"
    t.datetime "opening_time"
    t.datetime "closing_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "cash_total"
    t.float "cash_sale"
    t.index ["cash_id"], name: "index_cash_registers_on_cash_id"
  end

  create_table "cashes", force: :cascade do |t|
    t.string "cash_name"
    t.boolean "is_open"
    t.integer "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_cashes_on_admin_id"
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

  create_table "invoice_products", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.float "sale_price"
    t.integer "sale_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "Code"
    t.index ["sale_id"], name: "index_invoice_products_on_sale_id"
  end

  create_table "movements", force: :cascade do |t|
    t.float "cash_withdrawal"
    t.float "cash_deposit"
    t.string "reason"
    t.integer "cash_register_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cash_register_id"], name: "index_movements_on_cash_register_id"
  end

  create_table "others_for_sales", force: :cascade do |t|
    t.string "payment_method"
    t.float "other_value"
    t.integer "sale_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sale_id"], name: "index_others_for_sales_on_sale_id"
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

  create_table "products_sales", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "sale_id", null: false
    t.index ["product_id", "sale_id"], name: "index_products_sales_on_product_id_and_sale_id"
    t.index ["sale_id", "product_id"], name: "index_products_sales_on_sale_id_and_product_id"
  end

  create_table "profile_admins", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_profile_admins_on_admin_id"
  end

  create_table "sales", force: :cascade do |t|
    t.integer "quantity"
    t.float "total_price"
    t.string "payment_method"
    t.datetime "completed_at"
    t.string "status"
    t.string "comments"
    t.integer "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_id", null: false
    t.integer "discount"
    t.integer "cash_register_id", null: false
    t.float "taxes"
    t.float "customer_value"
    t.float "change"
    t.string "code"
    t.index ["admin_id"], name: "index_sales_on_admin_id"
    t.index ["cash_register_id"], name: "index_sales_on_cash_register_id"
    t.index ["customer_id"], name: "index_sales_on_customer_id"
  end

  create_table "sales_secondaryproducts", id: false, force: :cascade do |t|
    t.integer "secondaryproduct_id", null: false
    t.integer "sale_id", null: false
    t.index ["sale_id", "secondaryproduct_id"], name: "index_sales_secondaryproducts_on_sale_id_and_secondaryproduct_id"
    t.index ["secondaryproduct_id", "sale_id"], name: "index_sales_secondaryproducts_on_secondaryproduct_id_and_sale_id"
  end

  create_table "secondaryproducts", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_id"
    t.decimal "sale_price", precision: 10, scale: 2
    t.decimal "purchase_price", precision: 10, scale: 2
    t.integer "variation_id"
    t.integer "subgroup_id"
    t.index ["product_id"], name: "index_secondaryproducts_on_product_id"
    t.index ["subgroup_id"], name: "index_secondaryproducts_on_subgroup_id"
    t.index ["variation_id"], name: "index_secondaryproducts_on_variation_id"
  end

  create_table "subgroups", force: :cascade do |t|
    t.string "size"
    t.float "number"
    t.integer "quantity"
    t.integer "variation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["variation_id"], name: "index_subgroups_on_variation_id"
  end

  create_table "variations", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.string "variation_type"
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "variation_quantity"
    t.index ["product_id"], name: "index_variations_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cash_registers", "cashes"
  add_foreign_key "cashes", "admins"
  add_foreign_key "categories", "admins"
  add_foreign_key "customers", "admins"
  add_foreign_key "invoice_products", "sales"
  add_foreign_key "movements", "cash_registers"
  add_foreign_key "others_for_sales", "sales"
  add_foreign_key "products", "admins"
  add_foreign_key "products", "categories"
  add_foreign_key "profile_admins", "admins"
  add_foreign_key "sales", "admins"
  add_foreign_key "sales", "cash_registers"
  add_foreign_key "sales", "customers"
  add_foreign_key "secondaryproducts", "admins"
  add_foreign_key "secondaryproducts", "products"
  add_foreign_key "secondaryproducts", "subgroups"
  add_foreign_key "secondaryproducts", "variations"
  add_foreign_key "subgroups", "variations"
  add_foreign_key "variations", "products"
end
