class Accomplishment < ActiveRecord::Base
  
  belongs_to :subject
  belongs_to :user
  
  validates_presence_of :description, :created_at, :subject_id, :user_id
  
end
