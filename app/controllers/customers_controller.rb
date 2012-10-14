class CustomersController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    current_user.subscriber = Subscriber.create!
    current_user.stripe_card_token = params[:customer][:stripe_card_token]
    if current_user.save_stripe_customer
      flash[:analytics] = "/vp/add_credit_card"
      redirect_to plans_url, :notice => "Your billing information was updated."
    else
      flash.now[:alert] = "There was a problem with your credit card.  Please check your information."
      render :new
    end
  end
end