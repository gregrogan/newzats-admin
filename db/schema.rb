# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100918122214) do

  create_table "groups", :force => true do |t|
    t.string "name"
  end

  create_table "groups_members", :force => true do |t|
    t.integer "member_id"
    t.string  "group_id"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "addr_1"
    t.string   "addr_2"
    t.string   "addr_3"
    t.string   "addr_4"
    t.string   "post_code"
    t.string   "email"
    t.string   "phone_work"
    t.string   "phone_home"
    t.string   "phone_mobile"
    t.string   "fax"
    t.integer  "region_id"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "membershiptype_id"
    t.boolean  "email_invalid"
  end

  create_table "membershiptypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "member_id"
    t.string   "content"
    t.datetime "modification_time"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
