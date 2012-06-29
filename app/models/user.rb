class User < ActiveRecord::Base
  has_one :subscription, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessor :stripe_card_token

  before_destroy :delete_stripe_customer, if: :stripe_customer_token

  def save_stripe_customer
    if valid?
      unless Rails.env.test?
        if stripe_customer_token
          customer = Stripe::Customer.retrieve(stripe_customer_token)
          customer.card = stripe_card_token
          customer.save
        else
          customer = Stripe::Customer.create(email: email, card: stripe_card_token)
          self.stripe_customer_token = customer.id
        end
      end
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def delete_stripe_customer
    unless Rails.env.test?
      customer = Stripe::Customer.retrieve(stripe_customer_token)
      customer.delete
    end
  end

  def customer?
    stripe_customer_token.present?
  end
end
