class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def authenticate_customer!
    authenticate_user!
    raise ActiveRecord::RecordNotFound unless current_user.customer?
  end

  def authenticate_subscriber!
     authenticate_customer!
    raise ActiveRecord::RecordNotFound unless current_user.subscription.present?
  end
end
