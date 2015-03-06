class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def require_logged_in
    if !logged_in?
      redirect_to sign_in_path
    end
  end
  
  def logged_in?
    !!current_user
  end
  
  def current_user
    if session[:user_id] && !User.exists?(session[:user_id])
      session[:user_id] = nil
    else
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end  
    
end
