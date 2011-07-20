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

ActiveRecord::Schema.define(:version => 20110628223702) do

  create_table "accounts", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "series_organs", :force => true do |t|
    t.integer "serie_id",                    :null => false
    t.integer "organ_id",                    :null => false
    t.boolean "default",  :default => false, :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "kthid"
    t.string   "name"
    t.boolean  "admin"
    t.integer  "default_serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voucher_rows", :force => true do |t|
    t.integer  "voucher_id"
    t.integer  "account_id"
    t.decimal  "sum",            :precision => 10, :scale => 0
    t.integer  "arrangement_id"
    t.boolean  "canceled"
    t.integer  "changed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voucher_tags", :id => false, :force => true do |t|
    t.integer "voucher_id"
    t.integer "tag_id"
  end

  create_table "vouchers", :force => true do |t|
    t.integer  "number"
    t.integer  "serie_id"
    t.integer  "organ_id"
    t.datetime "accounting_date"
    t.integer  "created_by"
    t.integer  "activity_year"
    t.integer  "corrects"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
