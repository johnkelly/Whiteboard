class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_one  :subscription, dependent: :destroy

  def trial?
    ((Time.now - created_at.to_time) < 1.month.to_i) && subscription.try(:plan_id) == 1
  end

  def days_left_in_trial
    ((1.month.to_i - (Time.now - created_at.to_time)) / 1.day.to_i).round
  end
end