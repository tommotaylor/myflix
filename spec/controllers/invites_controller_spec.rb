require 'rails_helper'

describe InvitesController  do
  it "sets the @invite variable" do
    get :new
    expect(assigns(:invite)).to be_instance_of(Invite)
  end  
end