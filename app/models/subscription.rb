class Subscription < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :plan_id
  validates_uniqueness_of :user_id

  attr_accessible :plan_id

  before_save :update_stripe_subscription
  before_destroy :cancel_stripe_subscription

  def update_stripe_subscription
    if valid?
      unless Rails.env.test?
        if user.customer?
          customer = Stripe::Customer.retrieve(user.stripe_customer_token)
          customer.update_subscription(plan: plan_id)
        else
          false
        end
      end
    end
  end

  def cancel_stripe_subscription
    unless Rails.env.test?
      if user.customer?
        customer = Stripe::Customer.retrieve(user.stripe_customer_token)
        customer.cancel_subscription
      else
        false
      end
    end
  end

  def plan_name
    case plan_id
      when 1
        "Basic"
      when 2
        "Professional"
      when 3
        "Elite"
      else
        "Error"
    end
  end
end