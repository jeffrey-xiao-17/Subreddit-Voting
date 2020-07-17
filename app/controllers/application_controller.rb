class ApplicationController < ActionController::Base

  helper_method :logged_in?, :current_user

  def logged_in?
    session[:user_id]
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end
  
  def authenticate_user
    redirect_to "/login" unless logged_in?
  end

end
