class Subjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |table|
      table.column :name, :string
      table.column :user_id, :integer
    end
  end

  def self.down
    drop_table :subjects
  end
end
