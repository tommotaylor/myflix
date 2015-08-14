class InvitesController < ApplicationController

  before_action :require_user

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.user = current_user
    invitation = Invitation.new(invite_params, current_user)

    if invitation.friend_is_member?
      flash[:notice] = "This person is already a member"
      render :new
    elsif @invite.save
      invitation.send_invite(@invite)
      flash[:success] = "We have sent an invite to your friend"
      redirect_to home_path
    else
      flash[:error] = "Email can't be blank"
      render :new
    end
  end

private

  def invite_params
    params.require(:invite).permit(:friend_email, :friend_name, :message)
  end
end