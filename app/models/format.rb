class Format < ActiveRecord::Base
  
  validates_presence_of :body, :name
  
  has_many :logs
  
end
