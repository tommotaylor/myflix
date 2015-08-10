require 'rails_helper'

describe InvitesController  do
  describe "GET new" do
    it "sets the @invite variable" do
      user = Fabricate(:user)
      set_current_user(user)
      get :new
      expect(assigns(:invite)).to be_instance_of(Invite)
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    
    context "with valid inputs" do
      it "redirects to the home page" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite)
        expect(response).to redirect_to home_path
      end
      it "creates the invite" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite)
        expect(Invite.count).to eq(1)
      end
      it "creates the user association" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite)
        expect(Invite.first.user).to eq(user)
      end
      it "generates and saves the invite_token" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite)
        expect(Invite.first.invite_token).not_to be_nil
      end
    end

    context "sends emails" do
      after(:each) { ActionMailer::Base.deliveries.clear }
      it "sends an email" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite)        
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "sends the email to the friend_email" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite, friend_email: "friend@friend.com") 
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["friend@friend.com"])
      end
      it "sends the correct content" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite, message: "please join") 
        message = ActionMailer::Base.deliveries.last
        expect(message).to have_content("please join")  
      end
    end

    context "with invalid inputs" do
      it "doesn't create the invite if the email is blank" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite, friend_email: "")
        expect(Invite.count).to eq(0)
      end
      it "flashes an error if the friend_email is blank" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite, friend_email: "")
        expect(flash[:error]).to have_content("Email can't be blank")
      end
      it "doesn't create the invite if the friend is already a user" do
        user = Fabricate(:user)
        user2 = Fabricate(:user)
        set_current_user(user)
        post :create, invite: Fabricate.attributes_for(:invite, friend_email: user2.email)
        expect(Invite.count).to eq(0)
      end
    end
  end
end