class SubscribersController < ApplicationController
  before_filter :authenticate_subscriber!

  def show
    @subscriber = current_user.subscriber
    @users = @subscriber.users
    @subscription = @subscriber.subscription
    @whiteboards = @subscription.drawings if @subscription
    @user = User.new
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