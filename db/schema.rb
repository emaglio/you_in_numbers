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

ActiveRecord::Schema.define(version: 20170303220114) do

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.text     "content"
    t.text     "logo_meta_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "cpet_params"
    t.text     "cpet_results"
    t.text     "rmr_params"
    t.text     "rmr_results"
    t.text     "header"
    t.text     "subject"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "age"
    t.string   "phone"
    t.string   "gender"
    t.text     "auth_meta_data"
    t.boolean  "block"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
