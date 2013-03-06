class Name < ActiveRecord::Base
  acts_as_voteable

  validates :title, :presence => true
end
