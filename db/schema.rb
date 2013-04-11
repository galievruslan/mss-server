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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130411114308) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.string   "external_key"
    t.boolean  "validity",     :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "categories", ["external_key"], :name => "index_categories_on_external_key", :unique => true

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "external_key"
    t.boolean  "validity",     :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "customers", ["external_key"], :name => "index_customers_on_external_key", :unique => true

  create_table "manager_shipping_addresses", :force => true do |t|
    t.integer  "manager_id"
    t.integer  "shipping_address_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "managers", :force => true do |t|
    t.string   "name"
    t.string   "external_key"
    t.boolean  "validity",             :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "default_warehouse_id"
  end

  add_index "managers", ["external_key"], :name => "index_managers_on_external_key", :unique => true

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "unit_of_measure_id"
    t.integer  "quantity"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "orders", :force => true do |t|
    t.date     "date"
    t.text     "comment"
    t.integer  "shipping_address_id"
    t.integer  "manager_id"
    t.integer  "warehouse_id"
    t.integer  "price_list_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.datetime "exported_at"
    t.string   "external_key"
    t.integer  "route_point_id"
  end

  create_table "price_lists", :force => true do |t|
    t.string   "name"
    t.string   "external_key"
    t.boolean  "validity",     :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "price_lists", ["external_key"], :name => "index_price_lists_on_external_key", :unique => true

  create_table "product_prices", :force => true do |t|
    t.integer  "product_id"
    t.integer  "price_list_id"
    t.decimal  "price",         :precision => 7, :scale => 2
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "product_unit_of_measures", :force => true do |t|
    t.integer  "product_id"
    t.integer  "unit_of_measure_id"
    t.float    "count_in_base_unit"
    t.boolean  "base",               :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "external_key"
    t.boolean  "validity",     :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "category_id"
  end

  add_index "products", ["external_key"], :name => "index_products_on_external_key", :unique => true

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "route_points", :force => true do |t|
    t.integer  "shipping_address_id"
    t.integer  "status_id"
    t.integer  "route_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "external_key"
  end

  create_table "routes", :force => true do |t|
    t.date     "date"
    t.integer  "manager_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "external_key"
  end

  create_table "shipping_addresses", :force => true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.string   "address"
    t.string   "external_key"
    t.boolean  "validity",     :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "shipping_addresses", ["external_key"], :name => "index_shipping_addresses_on_external_key", :unique => true

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.boolean  "validity",   :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "template_route_points", :force => true do |t|
    t.integer  "template_route_id"
    t.integer  "shipping_address_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "template_routes", :force => true do |t|
    t.integer  "manager_id"
    t.integer  "day_of_week"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "unit_of_measures", :force => true do |t|
    t.string   "name"
    t.string   "external_key"
    t.boolean  "validity",     :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "unit_of_measures", ["external_key"], :name => "index_unit_of_measures_on_external_key", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "username"
    t.integer  "manager_id"
    t.integer  "list_page_size"
    t.string   "language"
    t.boolean  "banned",                 :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "warehouses", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "external_key"
    t.boolean  "validity",     :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "warehouses", ["external_key"], :name => "index_warehouses_on_external_key", :unique => true

end
