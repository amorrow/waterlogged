class Accomplishments < ActiveRecord::Migration
  def self.up
    create_table :accomplishments do |table|
      table.column :description, :text
      table.column :created_at, :datetime
      table.column :subject_id, :integer
      table.column :user_id, :integer
    end
  end

  def self.down
    drop_table :accomplishments
  end
end
