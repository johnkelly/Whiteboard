class SubscriptionsController < ApplicationController
  before_filter :authenticate_customer!
  
  def create
    if current_user.subscription.present?
      @subscription = current_user.subscription
      @subscription.plan_id = params[:plan_id]
    else
      @subscription = current_user.build_subscription(plan_id: params[:plan_id])
    end
    if @subscription.save
      redirect_to root_url, notice: "Your subscription plan has been updated."
    else
      redirect_to plans_url, alert: "There was an error changing your subscription plan.  Please try again later."
    end
  end

  def destroy
    @subscription = current_user.subscription
    @subscription.destroy
    redirect_to root_url, notice: "Your subscription has been canceled.  Let us know if there is anything we can do to make your Whiteboard experience better."
  end
end