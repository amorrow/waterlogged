class LogReminders < ActiveRecord::Migration
  def self.up
    create_table :log_reminders do |table|
      table.column :send_date, :datetime
      table.column :email, :string, :null => true, :default => nil
      table.column :subject, :string, :null => true, :default => nil
      table.column :reminder_format_id, :integer
      table.column :repeat, :boolean, :default => false
      table.column :repeat_type, :string, :null => true, :default => nil
      table.column :user_id, :integer
    end
  end

  def self.down
    drop_table :log_reminders
  end
end
