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
    if @user = User.find_by_password_reset_token(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        redirect_to invalid_token_path
      elsif 
        @user.update_attributes(user_params)
        @user.invalidate_token
        flash[:success] = "Your password was updated"
        redirect_to sign_in_path
      else
        render :edit
        flash[:error] = "something went wrong, try again"
      end
    else
      redirect_to invalid_token_path
    end
  end

  def confirm_password_reset
  end

  def invalid_token
  end

private

  def user_params
    params.require(:user).permit(:password)
  end

end