class UsersController < ApplicationController
  
  def new
    redirect_to home_path unless !signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Thanks for registering"
      redirect_to home_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

end