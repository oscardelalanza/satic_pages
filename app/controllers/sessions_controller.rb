class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user_url(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  # this will find the current logged user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def destroy; end
end
