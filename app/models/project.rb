class Project < ActiveRecord::Base
  belongs_to :subscription

  validates_presence_of :subscription_id
  validates_presence_of :name
  validates_length_of :name, :maximum => 50

  attr_accessible :name

end
