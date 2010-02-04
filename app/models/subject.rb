class Subject < ActiveRecord::Base
  
  belongs_to :user
  has_many :accomplishments, :dependent => :destroy
  has_and_belongs_to_many :waterlogs
  
  validates_presence_of :name, :user_id
  
  validates_inclusion_of :archived, :in => [true, false]
  
end
