class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_one  :subscription, dependent: :destroy
end