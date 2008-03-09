class LogReminder < ActiveRecord::Base
  belongs_to :user
  belongs_to :reminder_format
  belongs_to :log
  
  validates_presence_of :user_id, :reminder_format_id, :send_date, :email, :log_id
  validates_inclusion_of :repeat, :in => [true, false]
end
