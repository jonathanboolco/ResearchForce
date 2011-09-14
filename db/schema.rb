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

ActiveRecord::Schema.define(:version => 20110711173224) do

  create_table "services", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.string   "token"
    t.string   "token_secret"
    t.string   "token_refresh"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "instance_url"
    t.string   "org_id"
    t.string   "user_type"
    t.boolean  "active"
    t.string   "last_status_update"
    t.datetime "last_status_created_date"
    t.string   "profile"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",                    :default => false
    t.string   "nickname"
    t.string   "picture"
    t.string   "thumbnail"
    t.string   "user_id"
    t.string   "language"
    t.integer  "utcOffset"
    t.datetime "last_modified_date"
    t.string   "profile"
    t.boolean  "active"
    t.string   "user_type"
    t.string   "last_status_body"
    t.datetime "last_status_created_date"
    t.string   "org_id"
    t.string   "sfdc_token"
    t.string   "sfdc_refresh_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
