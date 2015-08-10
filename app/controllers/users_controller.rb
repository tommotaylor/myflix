class UsersController < ApplicationController

  before_action :require_user, only: :show

  def new
    redirect_to home_path unless !signed_in?
    if params[:invite_token]
      @invite = Invite.find_by(invite_token: params[:invite_token])
      @user = User.new(email: @invite.friend_email)
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.welcome_email(@user).deliver
      if params[:user][:invite_token]
        @invite = Invite.find_by(invite_token: params[:user][:invite_token])
        Relationship.create(follower: @invite.user, leader: @user)
        flash[:notice] = "Thanks for registering"
        redirect_to home_path
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

end