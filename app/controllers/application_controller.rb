class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user=(user)
    session[:user_id] = user.id if user
    current_user
  end
  
  def current_user
    @current_user ||= User.where(:_id => session[:user_id]).first
  end
  
  def ensure_logged_in
    redirect_to login_path unless current_user
  end
  
  helper_method :current_user
  
  rescue_from Mongoid::Errors::DocumentNotFound, :with => :error_404

  def error_404
    render :file => "#{Rails.root}/public/404.html", :status => :not_found
  end
  
end
