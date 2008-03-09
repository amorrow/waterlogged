class ReminderFormat < ActiveRecord::Base
  validates_presence_of :name, :body, :subject
end
