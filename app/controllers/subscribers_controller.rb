class SubscribersController < ApplicationController
  before_filter :authenticate_subscriber!

  def show
    @subscriber = current_user.subscriber
    @users = @subscriber.users
    @subscription = @subscriber.subscription
    @whiteboards = @subscription.drawings if @subscription
    @user = User.new
    flash.now[:notice] = "Your account admin will be able to change plans, update billing info, and delete your subscription from here." unless current_user.customer?
  end

  def add_user
    @subscriber = current_user.subscriber
    @user = @subscriber.users.new(params[:user])

    if @user.save
      flash[:notice] = "User added."
    else
      flash[:alert] = @user.errors.full_messages.first
    end
    redirect_to subscribers_url
  end
end