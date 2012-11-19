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

ActiveRecord::Schema.define(:version => 20121119195806) do

  create_table "account_groups", :force => true do |t|
    t.string   "title"
    t.integer  "account_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",       :null => false
  end

  create_table "accounts", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_group_id",                                                  :null => false
    t.decimal  "ingoing_balance",  :precision => 12, :scale => 2, :default => 0.0
    t.integer  "activity_year_id",                                                  :null => false
    t.boolean  "debet_is_normal",                                 :default => true
    t.boolean  "kredit_is_normal",                                :default => true
  end

  add_index "accounts", ["number", "activity_year_id"], :name => "index_accounts_on_number", :unique => true

  create_table "activity_years", :force => true do |t|
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_accesses", :force => true do |t|
    t.integer  "api_key_id",                 :null => false
    t.integer  "series_id",                  :null => false
    t.string   "read_write", :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_accesses", ["api_key_id"], :name => "index_api_accesses_on_api_key_id"
  add_index "api_accesses", ["series_id"], :name => "index_api_accesses_on_serie_id"

  create_table "api_keys", :force => true do |t|
    t.string   "key",                              :null => false
    t.string   "name",                             :null => false
    t.boolean  "revoked",       :default => false
    t.integer  "created_by_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "private_key",                      :null => false
  end

  add_index "api_keys", ["key"], :name => "index_api_keys_on_key", :unique => true

  create_table "arrangements", :force => true do |t|
    t.string   "name"
    t.integer  "organ_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",     :null => false
    t.integer  "valid_from"
    t.integer  "valid_to"
  end

  create_table "invoices", :force => true do |t|
    t.string   "counterpart"
    t.string   "reference"
    t.date     "expire_date"
    t.boolean  "supplier_invoice"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices_vouchers", :id => false, :force => true do |t|
    t.integer "invoice_id", :null => false
    t.integer "voucher_id", :null => false
  end

  create_table "journal", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message",     :null => false
    t.integer  "user_id"
    t.integer  "api_key_id"
    t.integer  "object_id"
    t.string   "object_type"
  end

  create_table "organs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
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

  create_table "template_input_fields", :force => true do |t|
    t.integer "voucher_template_id"
    t.string  "name"
    t.string  "description"
    t.string  "script_name"
  end

  add_index "template_input_fields", ["voucher_template_id"], :name => "index_template_input_fields_on_template_id"

  create_table "template_output_fields", :force => true do |t|
    t.integer "voucher_template_id"
    t.integer "account_number"
    t.string  "formula"
    t.string  "script_name"
  end

  add_index "template_output_fields", ["voucher_template_id"], :name => "index_template_output_fields_on_template_id"

  create_table "user_accesses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "series_id"
    t.integer  "granted_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_accesses", ["series_id"], :name => "index_user_accesses_on_serie_id"
  add_index "user_accesses", ["user_id"], :name => "index_user_accesses_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "ugid",                                 :null => false
    t.string   "login",                                :null => false
    t.string   "first_name",                           :null => false
    t.string   "last_name",                            :null => false
    t.string   "email",                                :null => false
    t.string   "persistence_token"
    t.boolean  "admin"
    t.integer  "default_series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "initials",                             :null => false
    t.boolean  "has_access",        :default => false
  end

  create_table "voucher_rows", :force => true do |t|
    t.integer  "voucher_id"
    t.decimal  "sum",            :precision => 12, :scale => 2
    t.integer  "arrangement_id"
    t.integer  "signature_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "canceled",                                      :default => false, :null => false
    t.integer  "account_number",                                                   :null => false
  end

  create_table "voucher_templates", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "template_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "valid_from"
    t.integer  "valid_to"
    t.boolean  "is_deleted",    :default => false
  end

  create_table "vouchers", :force => true do |t|
    t.integer  "number"
    t.integer  "series_id"
    t.integer  "organ_id"
    t.datetime "accounting_date"
    t.integer  "bookkept_by_id"
    t.integer  "activity_year_id"
    t.integer  "corrects_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "authorized_by_id"
    t.integer  "material_from_id"
    t.integer  "api_key_id"
    t.string   "slug",             :null => false
  end

  add_index "vouchers", ["slug"], :name => "index_vouchers_on_slug", :unique => true

end
