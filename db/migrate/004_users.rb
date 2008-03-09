class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |table|
      table.column :login, :string
      table.column :hashed_password, :string
      table.column :email, :string
      table.column :salt, :string
      table.column :created_at, :datetime
      table.column :name, :string
    end
  end

  def self.down
    drop_table :users
  end
end
