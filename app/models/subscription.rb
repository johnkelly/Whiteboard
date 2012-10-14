class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscriber
  has_many :drawings, dependent: :destroy

  validates_presence_of :user_id, :subscriber_id, :plan_id
  validates_uniqueness_of :user_id, :subscriber_id

  attr_accessible :plan_id, :subscriber_id

  before_save :update_stripe_subscription
  before_destroy :cancel_stripe_subscription

  def update_stripe_subscription
    if valid?
      unless Rails.env.test?
        if user.customer?
          customer = Stripe::Customer.retrieve(user.stripe_customer_token)
          if valid_credit_card?(customer)
            customer.update_subscription(plan: plan_id)
          else
            false
          end
        else
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

  private

  def valid_credit_card?(customer)
    credit_card = customer.active_card
    credit_card.cvc_check != "fail" && credit_card.address_zip_check != "fail" && credit_card.address_zip.present? && credit_card.name.present?
  end
end