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

ActiveRecord::Schema.define(version: 2023_07_17_173336) do

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

  create_table "products_sales", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "sale_id", null: false
    t.index ["product_id", "sale_id"], name: "index_products_sales_on_product_id_and_sale_id"
    t.index ["sale_id", "product_id"], name: "index_products_sales_on_sale_id_and_product_id"
  end

  create_table "sales", force: :cascade do |t|
    t.integer "product_id", null: false
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
    t.index ["admin_id"], name: "index_sales_on_admin_id"
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["product_id"], name: "index_sales_on_product_id"
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
    t.integer "quantity_variation"
    t.integer "variation_quantity"
    t.index ["product_id"], name: "index_variations_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "admins"
  add_foreign_key "customers", "admins"
  add_foreign_key "products", "admins"
  add_foreign_key "products", "categories"
  add_foreign_key "sales", "admins"
  add_foreign_key "sales", "customers"
  add_foreign_key "sales", "products"
  add_foreign_key "subgroups", "variations"
  add_foreign_key "variations", "products"
end
