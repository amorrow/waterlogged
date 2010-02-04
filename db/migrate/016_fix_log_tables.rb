class FixLogTables < ActiveRecord::Migration
  def self.up
    rename_table :logs, :waterlogs
    
    drop_table :logs_subjects
    
    create_table :subjects_waterlogs, :force => true, :id => false do |t|
      t.integer :waterlog_id
      t.integer :subject_id
    end
  end

  def self.down
    drop_table :subjects_waterlogs
    
    create_table :logs_subects, :force => true, :id => false do |t|
      t.integer :log_id
      t.integer :subject_id
    end
    
    rename_table :waterlogs, :logs
  end
end
