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
    result = UserSignup.new(@user).signup(stripeToken: params[:stripeToken], invite_token: params[:user][:token])
    if result.successful?
      session[:user_id] = @user.id
      flash[:notice] = "Thanks for registering"
      redirect_to home_path
    elsif result.invalid_invite?
      redirect_to invalid_token_path
    else
      flash.now[:error] = result.error_message
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

  
end