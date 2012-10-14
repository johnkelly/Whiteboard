class SubscribersController < ApplicationController
  before_filter :authenticate_subscriber!

  def show
    @subscriber = current_user.subscriber
    @users = @subscriber.users
    @subscription = @subscriber.subscription
    @whiteboards = @subscription.drawings if @subscription
  end
end