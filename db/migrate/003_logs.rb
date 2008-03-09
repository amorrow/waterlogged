class Logs < ActiveRecord::Migration
  def self.up
    create_table :logs do |table|
      table.column :name, :string
      table.column :user_id, :integer
      table.column :last_exported, :datetime
      table.column :format_id, :integer
    end
  end

  def self.down
    drop_table :logs
  end
end
