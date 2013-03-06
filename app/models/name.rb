class Name < ActiveRecord::Base
  acts_as_voteable
  belongs_to :user
  attr_accessible :title, :subtitle, :user

  validates :title, :presence => true
end
