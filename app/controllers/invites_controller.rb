class InvitesController < ApplicationController

  def new
    @invite = Invite.new
  end

end