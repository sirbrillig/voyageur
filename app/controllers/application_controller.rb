class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :authenticate_admin

  protected 

  def authenticate_admin
    unless user_signed_in? and current_user.admin?
      if user_signed_in?
        redirect_to locations_url, alert: 'You are not authorized for that action, sorry.'
      else
        redirect_to root_url, alert: 'You are not authorized for that action, sorry.'
      end
    end
  end
end
