class User < ActiveRecord::Base
  belongs_to :subscriber

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessor :stripe_card_token

  before_destroy :delete_stripe_customer, if: :stripe_customer_token
  before_create :enforce_plan_limit

  delegate :subscription, to: :subscriber

  def save_stripe_customer
    if valid? && valid_credit_card?
      if customer?
        update_existing_stripe_customer
      else
        create_new_stripe_customer
      end
      save!
    else
      false
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe error while subscribing customer: #{e.message}"
    self.stripe_card_token = nil
    false
  end

  def customer?
    stripe_customer_token.present?
  end

  def subscriber?
    subscriber.present?
  end

  def trial_user?
    (Time.now - created_at.to_time) < 1.month.to_i
  end

  def create_new_stripe_customer
    unless Rails.env.test?
      customer = Stripe::Customer.create(email: email, card: stripe_card_token)
      self.stripe_customer_token = customer.id
    end
  end

  def update_existing_stripe_customer
    unless Rails.env.test?
      customer = Stripe::Customer.retrieve(stripe_customer_token)
      customer.card = stripe_card_token
      customer.save
    end
  end

  def delete_stripe_customer
    unless Rails.env.test?
      customer = Stripe::Customer.retrieve(stripe_customer_token)
      customer.delete
    end
  end

  def enforce_plan_limit
    if self.try(:subscriber).try(:subscription).present?
      if self.subscriber.users.count >= self.subscriber.subscription.plan_allowed_users
      errors.add(:base, "All the accounts for your company have been taken.  Please contact your administrator to upgrade your company's account to a higher plan.")
      false
      end
    end
  end

  private

  def valid_credit_card?
    unless Rails.env.test?
      credit_card = Stripe::Token.retrieve(stripe_card_token).card
      credit_card.cvc_check != "fail" && credit_card.address_zip_check != "fail" && credit_card.address_zip.present? && credit_card.name.present?
    else
      true
    end
  end
end
