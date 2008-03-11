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

ActiveRecord::Schema.define(:version => 15) do

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

  create_table "logs", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "last_exported"
    t.integer  "format_id"
  end

  create_table "logs_subjects", :id => false, :force => true do |t|
    t.integer "log_id"
    t.integer "subject_id"
  end

  add_index "logs_subjects", ["subject_id"], :name => "index_logs_subjects_on_subject_id"
  add_index "logs_subjects", ["log_id"], :name => "index_logs_subjects_on_log_id"

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

end
