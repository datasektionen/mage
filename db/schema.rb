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

ActiveRecord::Schema.define(:version => 20110726185254) do

  create_table "accounts", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.integer  "account_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["number"], :name => "index_accounts_on_number", :unique => true

  create_table "activity_years", :force => true do |t|
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "arrangements", :force => true do |t|
    t.string   "name"
    t.integer  "organ_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",     :null => false
  end

  create_table "journal", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", :force => true do |t|
    t.string   "name"
    t.string   "letter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_organ_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_vouchers", :id => false, :force => true do |t|
    t.integer "voucher_id"
    t.integer "tag_id"
  end

  add_index "tags_vouchers", ["tag_id"], :name => "index_vouchers_tags_on_tag_id"
  add_index "tags_vouchers", ["voucher_id"], :name => "index_vouchers_tags_on_voucher_id"

  create_table "user_accesses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "serie_id"
    t.integer  "granted_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_accesses", ["serie_id"], :name => "index_user_accesses_on_serie_id"
  add_index "user_accesses", ["user_id"], :name => "index_user_accesses_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "ugid",              :null => false
    t.string   "login",             :null => false
    t.string   "first_name",        :null => false
    t.string   "last_name",         :null => false
    t.string   "email",             :null => false
    t.string   "persistence_token"
    t.boolean  "admin"
    t.integer  "default_serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "initials",          :null => false
  end

  create_table "voucher_rows", :force => true do |t|
    t.integer  "voucher_id"
    t.decimal  "sum",            :precision => 10, :scale => 0
    t.integer  "arrangement_id"
    t.integer  "signature_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "canceled",                                      :default => false, :null => false
    t.integer  "account_number",                                                   :null => false
  end

  create_table "vouchers", :force => true do |t|
    t.integer  "number"
    t.integer  "serie_id"
    t.integer  "organ_id"
    t.datetime "accounting_date"
    t.integer  "created_by_id"
    t.integer  "activity_year_id"
    t.integer  "corrects_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

end
