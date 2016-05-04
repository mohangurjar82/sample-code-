# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160504170530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "order",       default: 0
    t.integer  "category_id"
    t.string   "image_url"
    t.string   "number"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image"
  end

  add_index "categories", ["category_id"], name: "index_categories_on_category_id", using: :btree
  add_index "categories", ["number"], name: "index_categories_on_number", using: :btree

  create_table "favorite_media", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "favorite_media", ["media_number"], name: "index_favorite_media_on_media_number", using: :btree
  add_index "favorite_media", ["user_id"], name: "index_favorite_media_on_user_id", using: :btree

  create_table "media", force: :cascade do |t|
    t.integer  "admin_user_id"
    t.string   "title"
    t.text     "description"
    t.string   "number"
    t.string   "image_url"
    t.string   "source_url"
    t.text     "extra_sources"
    t.string   "language"
    t.integer  "rating",        default: 0
    t.integer  "price",         default: 99
    t.integer  "order",         default: 0
    t.text     "embedded_code"
    t.text     "text"
    t.text     "overlay_code"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "image"
  end

  add_index "media", ["number"], name: "index_media_on_number", using: :btree

  create_table "media_categories", force: :cascade do |t|
    t.integer  "medium_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "media_categories", ["category_id"], name: "index_media_categories_on_category_id", using: :btree
  add_index "media_categories", ["medium_id"], name: "index_media_categories_on_medium_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id",        null: false
    t.integer  "order_id",          null: false
    t.decimal  "price"
    t.string   "subscription_unit"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "order_items", ["order_id", "product_id"], name: "index_order_items_on_order_id_and_product_id", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "mpxid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payment_details", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "card_number"
    t.string   "card_type"
    t.string   "stripe_customer_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "pricing_plans", force: :cascade do |t|
    t.string   "title"
    t.integer  "price",             default: 99
    t.string   "interval",          default: "month"
    t.integer  "interval_count",    default: 1
    t.integer  "trial_period_days", default: 0
    t.string   "unique_key"
    t.string   "stripe_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "product_items", force: :cascade do |t|
    t.integer  "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "item_id"
    t.string   "item_type"
  end

  add_index "product_items", ["product_id"], name: "index_product_items_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "images",          default: [],                array: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.json     "pricing_plan"
    t.boolean  "available",       default: true, null: false
    t.string   "mpxid"
    t.string   "image"
    t.integer  "pricing_plan_id"
  end

  create_table "subscription_items", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "price"
    t.string   "billing_period"
    t.string   "stripe_id"
    t.integer  "product_id"
    t.string   "stripe_plan_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                     default: "", null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "mpx_token"
    t.string   "mpx_user_id"
    t.json     "billing_address"
    t.string   "name"
    t.text     "recently_viewed_media_ids", default: [],              array: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
