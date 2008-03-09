class CreateReminderFormats < ActiveRecord::Migration
  def self.up
    create_table :reminder_formats do |t|
      t.column :name, :string
      t.column :body, :text
    end
  end

  def self.down
    drop_table :reminder_formats
  end
end
