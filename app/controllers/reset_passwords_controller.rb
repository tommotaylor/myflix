class ResetPasswordsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to confirm_password_reset_path
  end

  def edit
    @user = User.find_by_password_reset_token(params[:id])
  end

  def update
  end

  def confirm_password_reset
  end

  def invalid_token
  end


end