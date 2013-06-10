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

ActiveRecord::Schema.define(:version => 20130609170247) do

  create_table "carts", :force => true do |t|
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_credits", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.integer  "credits_available"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "customer_credits_useds", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",            :null => false
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "phone_number"
    t.integer  "drop_location_id"
    t.string   "account_status"
    t.string   "mailing_list"
    t.string   "contact_method"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.text     "notes"
    t.string   "share_type"
    t.date     "hold_date"
    t.integer  "order_count"
  end

  create_table "drop_locations", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "link"
    t.string   "day"
    t.string   "time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.time     "start_time"
    t.time     "end_time"
    t.date     "start_date"
    t.text     "info"
  end

  create_table "hold_dates", :force => true do |t|
    t.integer  "customer_id"
    t.date     "date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "quantity",   :limit => 8
    t.decimal  "price",                   :precision => 10, :scale => 2
    t.decimal  "decimal",                 :precision => 10, :scale => 2
    t.integer  "product_id"
    t.string   "status"
    t.string   "tracking"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "cart_id"
  end

  create_table "models", :force => true do |t|
    t.string   "email",                                 :null => false
    t.string   "encrypted_password",                    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "models", ["email"], :name => "index_models_on_email", :unique => true
  add_index "models", ["reset_password_token"], :name => "index_models_on_reset_password_token", :unique => true

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "cart_id",          :null => false
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.integer  "customer_id",      :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "amount",     :default => 1
    t.string   "token"
    t.string   "identifier"
    t.string   "payer_id"
    t.boolean  "recurring",  :default => false
    t.boolean  "digital",    :default => false
    t.boolean  "popup",      :default => false
    t.boolean  "completed",  :default => false
    t.boolean  "canceled",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preferences", :force => true do |t|
    t.integer  "customer_id"
    t.boolean  "squid"
    t.boolean  "mackerel"
    t.boolean  "skate"
    t.boolean  "monkfish"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "clams"
    t.boolean  "mussels"
    t.boolean  "oysters"
    t.boolean  "scallops"
  end

  create_table "processed_locations", :force => true do |t|
    t.integer  "drop_location_id"
    t.date     "date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "category"
    t.string   "name"
    t.text     "description"
    t.string   "option"
    t.decimal  "price",       :precision => 8, :scale => 2
    t.integer  "stock"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "credits"
    t.string   "share_type"
    t.string   "image_url"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "share_types", :force => true do |t|
    t.string   "share_type"
    t.string   "abbreviation"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "text_entries", :force => true do |t|
    t.string   "name"
    t.text     "entry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "used_customer_credits", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.integer  "credits_used"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :null => false
    t.string   "encrypted_password",                    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
