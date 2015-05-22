class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def require_user
    if !signed_in?
      flash[:error] = "Please login first."
      redirect_to sign_in_path
    end
  end

end
