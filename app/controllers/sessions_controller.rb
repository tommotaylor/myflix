class SessionsController < ApplicationController
  
  def new
    redirect_to home_path unless !signed_in?
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:notice] = "Welcome, you've logged in."
        redirect_to home_path
      else
        flash[:error] = "Your account has been deactivated as we couldn't charge your card, please contact customer services"
        redirect_to sign_in_path
      end
    else
      flash[:error] = "There is something wrong with your username or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out."
    redirect_to front_path
  end
  
end
