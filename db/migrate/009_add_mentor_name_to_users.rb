class AddMentorNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mentor_name, :string
  end

  def self.down
    remove_column :users, :mentor_name
  end
end
