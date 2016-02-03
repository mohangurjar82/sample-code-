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

ActiveRecord::Schema.define(version: 20160203124713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "shopify_uid",            limit: 255
    t.string   "shopify_token",          limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  add_index "accounts", ["shopify_uid"], name: "index_accounts_on_shopify_uid", unique: true, using: :btree

  create_table "mockup_orders", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_details", id: false, force: :cascade do |t|
    t.integer "order_number"
    t.integer "item_number"
    t.text    "detail_date"
    t.text    "adjustment"
    t.text    "product"
    t.text    "price_per_unit"
    t.text    "cost_per_unit"
    t.text    "quantity_ordered"
    t.text    "quantity_shipped"
    t.text    "quantity_returned"
    t.text    "backordered"
    t.text    "billed_subtotal"
    t.text    "shipped_subtotal"
    t.text    "final_subtotal"
    t.text    "unit_weight"
    t.text    "finite_options"
    t.text    "freeform_options"
    t.text    "sku"
    t.text    "option01"
    t.text    "option02"
    t.text    "option03"
    t.text    "option04"
    t.text    "option05"
    t.text    "option06"
    t.text    "option07"
    t.text    "option08"
    t.text    "option09"
    t.text    "option10"
    t.text    "quantity_needed"
    t.text    "date_shipped"
    t.text    "expected_ship_date"
    t.text    "actual_weight"
    t.text    "drop_ship"
    t.text    "drop_ship_order_number"
    t.text    "drop_ship_notes"
    t.text    "drop_ship_supplier"
    t.text    "status"
    t.text    "product_type"
    t.text    "extra_currency1"
    t.text    "extra_currency2"
    t.text    "extra_currency3"
    t.text    "extra_currency4"
    t.text    "extra_currency5"
    t.text    "parent"
    t.text    "order_type"
    t.text    "taxable"
    t.text    "dimension"
    t.text    "qb_import"
    t.text    "hc_item_num"
    t.text    "quantity_packed"
    t.text    "text1"
    t.text    "text2"
    t.text    "text3"
    t.text    "text4"
    t.text    "text5"
    t.text    "integer1"
    t.text    "integer2"
    t.text    "integer3"
    t.text    "integer4"
    t.text    "integer5"
    t.text    "date1"
    t.text    "date2"
    t.text    "date3"
    t.text    "date4"
    t.text    "date5"
    t.text    "ebay_auction_id"
    t.text    "ebay_sale_id"
    t.text    "status_changed"
    t.text    "item_stat_detail"
    t.text    "fulfillment_status"
    t.text    "fulfillment_time"
    t.text    "suppliers_sku"
    t.text    "parent_sku"
    t.text    "retail_price"
    t.text    "fulfillment_center"
    t.text    "bt_sent"
    t.text    "assumed_packed"
    t.text    "uid"
    t.text    "web_item_status"
    t.text    "external_fulfillment"
    t.text    "market_line_id"
    t.text    "web_sku"
    t.text    "time_stamp"
  end

  create_table "orders", primary_key: "order_number", force: :cascade do |t|
    t.text "order_source"
    t.text "source_order_number"
    t.text "order_date"
    t.text "order_time"
    t.text "customer_id"
    t.text "name"
    t.text "company"
    t.text "email"
    t.text "address"
    t.text "address2"
    t.text "city"
    t.text "state"
    t.text "zip"
    t.text "country"
    t.text "phone"
    t.text "ship_name"
    t.text "ship_company"
    t.text "ship_address"
    t.text "ship_address2"
    t.text "ship_city"
    t.text "ship_state"
    t.text "ship_zip"
    t.text "ship_country"
    t.text "ship_phone"
    t.text "pay_type"
    t.text "pay1"
    t.text "pay2"
    t.text "pay3"
    t.text "pay4"
    t.text "cc_info"
    t.text "ship_on"
    t.text "order_inst"
    t.text "comments"
    t.text "product_total"
    t.text "tax_total"
    t.text "shipping_total"
    t.text "grand_total"
    t.text "num_items"
    t.text "viewed"
    t.text "shipping"
    t.text "discount"
    t.text "revised_discount"
    t.text "coupon"
    t.text "coupon_discount"
    t.text "coupon_ok"
    t.text "surcharge"
    t.text "revised_surcharge"
    t.text "ref_name"
    t.text "gift_message"
    t.text "approved"
    t.text "cancelled"
    t.text "final_product_total"
    t.text "final_tax_total"
    t.text "final_shipping_total"
    t.text "final_grand_total"
    t.text "balance_due"
    t.text "credit_issued"
    t.text "review_reason"
    t.text "back_orders_to_fill"
    t.text "shipped_weight"
    t.text "final_tax_rate"
    t.text "notes"
    t.text "revised_coupon_discount"
    t.text "note_to_customer"
    t.text "discounts_active"
    t.text "taxable"
    t.text "tax_number"
    t.text "actual_shipped_weight"
    t.text "discount_type"
    t.text "discount_percent"
    t.text "surcharge_details"
    t.text "drop_ships_any"
    t.text "drop_ships_done"
    t.text "local_sort_text1"
    t.text "local_sort_text2"
    t.text "local_sort_text3"
    t.text "local_sort_text4"
    t.text "local_sort_text5"
    t.text "local_sort_integer1"
    t.text "local_sort_integer2"
    t.text "local_sort_integer3"
    t.text "local_sort_integer4"
    t.text "local_sort_integer5"
    t.text "local_sort_date1"
    t.text "local_sort_date2"
    t.text "local_sort_date3"
    t.text "local_sort_date4"
    t.text "local_sort_date5"
    t.text "tax_by_pos"
    t.text "date_created"
    t.text "source_order_id"
    t.text "local_sort_currency1"
    t.text "local_sort_currency2"
    t.text "local_sort_currency3"
    t.text "local_sort_currency4"
    t.text "local_sort_currency5"
    t.text "email_cc"
    t.text "import_id"
    t.text "add_to_email_list"
    t.text "payment_string"
    t.text "customer_ip"
    t.text "order_status"
    t.text "order_status_changed"
    t.text "ord_stat_detail"
    t.text "exported"
    t.text "cart_id"
    t.text "approval_date"
    t.text "inv_print"
    t.text "pack_print"
    t.text "web_id"
    t.text "fraud_score"
    t.text "po_number"
    t.text "terms"
    t.text "pay5"
    t.text "pay6"
    t.text "expected_net"
    t.text "actual_net"
    t.text "pay7"
    t.text "pay8"
    t.text "pay9"
    t.text "designation"
    t.text "hours_to_gmt"
    t.text "register_id"
    t.text "pay10"
    t.text "shift_id"
    t.text "global_cart_id"
    t.text "ship_email"
    t.text "trans_in_progress"
    t.text "entered_by"
    t.text "approved_by"
    t.text "old_designation"
    t.text "road_trip"
    t.text "trade_show"
    t.text "state_change_date"
    t.text "state_change_by"
    t.text "state_change_reason"
    t.text "tax_system_used"
    t.text "tax_amount_committed"
    t.text "tax_system_record_id"
    t.text "tax_calc_date"
    t.text "tax_system_record_counter"
    t.text "tax_shipping"
    t.text "market_name"
    t.text "market_order_id"
    t.text "market_customer_id"
    t.text "web_order_status"
    t.text "efi_status"
    t.text "time_stamp"
  end

  add_index "orders", ["order_number"], name: "order_number_index", using: :btree

  create_table "sheets", force: :cascade do |t|
    t.integer  "account_id",                 null: false
    t.integer  "parent_file_id"
    t.integer  "mapping_id"
    t.string   "title",          limit: 255
    t.string   "file",           limit: 255
    t.integer  "header_row"
    t.integer  "key_row"
    t.integer  "parent_key_row"
    t.text     "headers"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", limit: 255, null: false
    t.string   "shopify_token",  limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "mpx_token"
    t.string   "mpx_user_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
