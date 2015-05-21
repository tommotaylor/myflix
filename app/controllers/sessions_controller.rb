class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, you've logged in."
      redirect_to home_path
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
