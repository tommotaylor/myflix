class UsersController < ApplicationController

  before_action :require_user, only: :show

  def new
    redirect_to home_path unless !signed_in?
    if params[:token]
      if @invite = Invite.find_by(token: params[:token])
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
      StripeWrapper::Charge.create(
        :amount => 999,
        :source => params[:stripeToken]
        )
      AppMailer.welcome_email(@user).deliver
      session[:user_id] = @user.id
      if params[:user][:token]
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
    if @invite = Invite.find_by(token: params[:user][:token])
      @user.follow(@invite.user)
      @invite.user.follow(@user)
      @invite.update_attributes!(token: nil)
      flash[:notice] = "Thanks for registering"
      redirect_to home_path
    else
      redirect_to invalid_token_path
    end
  end
end