class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscriber
  has_many :drawings, dependent: :destroy

  validates_presence_of :user_id, :subscriber_id, :plan_id
  validates_uniqueness_of :user_id, :subscriber_id

  attr_accessible :plan_id, :user_id

  before_save :check_user_limit, :update_stripe_subscription
  before_destroy :cancel_stripe_subscription

  def update_stripe_subscription
    if valid?
      unless Rails.env.test?
        if user.customer?
          customer = Stripe::Customer.retrieve(user.stripe_customer_token)
          if valid_credit_card?(customer)
            customer.update_subscription(plan: plan_id)
          else
            errors.add(:base, "There was an error changing your subscription plan.  Please try again later.  If the problem continues, please update your billing information.")
            false
          end
        else
          errors.add(:base, "There was an error changing your subscription plan.  Please try again later.  If the problem continues, please update your billing information.")
          false
        end
      end
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    false
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
        "Starter"
      when 2
        "Small Business"
      when 3
        "Enterprise"
      else
        "Error"
    end
  end

  def plan_allowed_users
    case plan_id
      when 1
        5
      when 2
        25
      when 3
        125
      else
        "Error"
    end
  end

  def check_user_limit
    if subscriber.users.size > plan_allowed_users
      errors.add(:base, "The plan you are switching to has a lower user limit.  Please delete users before switching plans.")
      false
    end
  end

  def plan_allowed_whiteboards
    case plan_id
      when 1
        500
      when 2
        5000
      when 3
        50000
      else
        "Error"
    end
  end


  private

  def valid_credit_card?(customer)
    credit_card = customer.active_card
    credit_card.cvc_check != "fail" && credit_card.address_zip_check != "fail" && credit_card.address_zip.present? && credit_card.name.present?
  end
end