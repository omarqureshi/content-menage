class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user=(user)
    session[:user_id] = user.id if user
    current_user
  end
  
  def current_user
    @current_user ||= User.where(:_id => session[:user_id]).first
  end
  helper_method :current_user
  
end
