class AddLogIdToLogReminders < ActiveRecord::Migration
  def self.up
    add_column :log_reminders, :log_id, :integer
  end

  def self.down
    remove_column :log_reminders, :log_id
  end
end
