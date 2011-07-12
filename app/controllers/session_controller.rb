class SessionController < ApplicationController
  
  def new
  end
  
  def create
    user = User.with_email(params[:email]).first.try(:authenticate, params[:password])
    self.current_user = user
    if current_user
      redirect_to params[:return_to] || content_index_path
    else
      render :action => "new"
    end
  end
  
  def destroy
    reset_session
    redirect_to params[:return_to] || "/"
  end
  
end
