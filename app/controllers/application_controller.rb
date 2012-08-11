class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    url = root_url

    if current_user.subscriber?
      url = projects_url
    elsif current_user.customer?
      url = plans_url
    elsif current_user
      url = new_customer_url
    end

    url
  end

  protected

  def authenticate_customer!
    authenticate_user!
    raise ActiveRecord::RecordNotFound unless current_user.customer?
  end

  def authenticate_subscriber!
     authenticate_customer!
    raise ActiveRecord::RecordNotFound unless current_user.subscriber?
  end
end
