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

ActiveRecord::Schema.define(:version => 20100608124654) do

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
    t.integer  "group_id"
    t.integer  "membership_type_id"
    t.date     "date_joined"
    t.boolean  "council"
    t.boolean  "admissions"
    t.boolean  "leave"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
