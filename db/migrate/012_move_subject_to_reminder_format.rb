class MoveSubjectToReminderFormat < ActiveRecord::Migration
  def self.up
    remove_column :log_reminders, :subject
    add_column :reminder_formats, :subject, :string
  end

  def self.down
    remove_column :reminder_formats, :subject
    add_column :log_reminders, :subject, :string
  end
end
