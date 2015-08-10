class UsersController < ApplicationController

  before_action :require_user, only: :show

  def new
    redirect_to home_path unless !signed_in?
    if params[:invite_token]
      if @invite = Invite.find_by(invite_token: params[:invite_token])
        @user = User.new(email: @invite.friend_email)
      else
        redirect_to invalid_token_path
      end
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.welcome_email(@user).deliver
      session[:user_id] = @user.id
      if params[:user][:invite_token]
        handle_invited_user
      else
        flash[:notice] = "Thanks for registering"
        redirect_to home_path
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

  def handle_invited_user
    if @invite = Invite.find_by(invite_token: params[:user][:invite_token])
      @user.follow(@invite.user)
      @invite.user.follow(@user)
      @invite.update_attributes!(invite_token: nil)
      flash[:notice] = "Thanks for registering"
      redirect_to home_path
    else
      redirect_to invalid_token_path
    end
  end
end