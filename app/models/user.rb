class User < ActiveRecord::Base
  has_one :subscription, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessor :stripe_card_token

  before_destroy :delete_stripe_customer, if: :stripe_customer_token

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
