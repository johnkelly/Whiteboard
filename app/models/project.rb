class Project < ActiveRecord::Base
  belongs_to :subscription
  has_many :project_images, dependent: :destroy

  validates_presence_of :subscription_id
  validates_presence_of :name
  validates_length_of :name, :maximum => 50

  attr_accessible :name

end
