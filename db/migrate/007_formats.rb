class Formats < ActiveRecord::Migration
  def self.up
    create_table :formats do |table|
      table.column :body, :text
      table.column :name, :string, :null => true, :default => nil
    end
  end

  def self.down
    drop_table :formats
  end
end
