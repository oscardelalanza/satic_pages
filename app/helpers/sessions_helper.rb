module SessionsHelper
  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # this will find the current logged user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # return true if the user is logged in
  def logged_in?
    !current_user.nil?
  end
end
