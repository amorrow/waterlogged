class LogsSubjects < ActiveRecord::Migration
  def self.up
    create_table :logs_subjects, :id => false do |table|
      table.column :log_id, :integer
      table.column :subject_id, :integer
    end
    add_index :logs_subjects, [:log_id]
    add_index :logs_subjects, [:subject_id]
  end

  def self.down
    drop_table :logs_subjects
  end
end
