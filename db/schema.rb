# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 16) do

  create_table "accomplishments", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.integer  "subject_id"
    t.integer  "user_id"
  end

  create_table "formats", :force => true do |t|
    t.text   "body"
    t.string "name"
  end

  create_table "log_reminders", :force => true do |t|
    t.datetime "send_date"
    t.string   "email"
    t.integer  "reminder_format_id"
    t.boolean  "repeat",             :default => false
    t.string   "repeat_type"
    t.integer  "user_id"
    t.integer  "log_id"
  end

  create_table "reminder_formats", :force => true do |t|
    t.string "name"
    t.text   "body"
    t.string "subject"
  end

  create_table "subjects", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
    t.boolean "archived"
  end

  create_table "subjects_waterlogs", :id => false, :force => true do |t|
    t.integer "waterlog_id"
    t.integer "subject_id"
  end

  create_table "user_reminders", :force => true do |t|
    t.datetime "send_date"
    t.string   "email"
    t.string   "subject"
    t.text     "body"
    t.boolean  "repeat",      :default => false
    t.string   "repeat_type"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "hashed_password"
    t.string   "email"
    t.string   "salt"
    t.datetime "created_at"
    t.string   "name"
    t.string   "mentor_name"
    t.boolean  "enabled",         :default => true
    t.boolean  "admin",           :default => false
  end

  create_table "waterlogs", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "last_exported"
    t.integer  "format_id"
  end

end
