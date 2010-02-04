class Waterlog < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :format
  has_and_belongs_to_many :subjects
  
  validates_presence_of :name, :user_id, :last_exported, :format_id
  
end
