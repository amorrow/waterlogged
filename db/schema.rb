# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 15) do

  create_table "accomplishments", :force => true do |t|
    t.column "description", :text
    t.column "created_at",  :datetime
    t.column "subject_id",  :integer
    t.column "user_id",     :integer
  end

  create_table "formats", :force => true do |t|
    t.column "body", :text
    t.column "name", :string
  end

  create_table "log_reminders", :force => true do |t|
    t.column "send_date",          :datetime
    t.column "email",              :string
    t.column "reminder_format_id", :integer
    t.column "repeat",             :boolean,  :default => false
    t.column "repeat_type",        :string
    t.column "user_id",            :integer
    t.column "log_id",             :integer
  end

  create_table "logs", :force => true do |t|
    t.column "name",          :string
    t.column "user_id",       :integer
    t.column "last_exported", :datetime
    t.column "format_id",     :integer
  end

  create_table "logs_subjects", :id => false, :force => true do |t|
    t.column "log_id",     :integer
    t.column "subject_id", :integer
  end

  add_index "logs_subjects", ["log_id"], :name => "index_logs_subjects_on_log_id"
  add_index "logs_subjects", ["subject_id"], :name => "index_logs_subjects_on_subject_id"

  create_table "reminder_formats", :force => true do |t|
    t.column "name",    :string
    t.column "body",    :text
    t.column "subject", :string
  end

  create_table "subjects", :force => true do |t|
    t.column "name",     :string
    t.column "user_id",  :integer
    t.column "archived", :boolean
  end

  create_table "user_reminders", :force => true do |t|
    t.column "send_date",   :datetime
    t.column "email",       :string
    t.column "subject",     :string
    t.column "body",        :text
    t.column "repeat",      :boolean,  :default => false
    t.column "repeat_type", :string
    t.column "user_id",     :integer
  end

  create_table "users", :force => true do |t|
    t.column "login",           :string
    t.column "hashed_password", :string
    t.column "email",           :string
    t.column "salt",            :string
    t.column "created_at",      :datetime
    t.column "name",            :string
    t.column "mentor_name",     :string
    t.column "enabled",         :boolean,  :default => true
    t.column "admin",           :boolean,  :default => false
  end

end