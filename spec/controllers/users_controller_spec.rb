require 'rails_helper'

describe UsersController do

  describe "GET new" do
    it "sets @user if not signed in" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
    it "sets the @invite variable if in the params" do
      invite = Fabricate(:invite, token: 12345)
      get :new, token: 12345
      expect(assigns(:invite)).to eq(invite)
    end
    it "redirects to home if signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
  end

  describe "POST create" do
    before do
      StripeWrapper::Charge.stub(:create)
    end
    context "if validations met" do
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "creates a new user" do
        expect(User.count).to eq(1)
      end
      it "redirects to home path" do
        expect(response).to redirect_to(home_path)
      end
    end
    context "if validations not met" do
      before do 
        post :create, user: Fabricate.attributes_for(:user, email: "")
      end
      it "doesn't create a new user" do
        expect(User.count).to eq(0)
      end
      it "renders :new" do
        expect(response).to render_template(:new)
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
    context "sends emails" do
      after(:each) { ActionMailer::Base.deliveries.clear }
      it "sends an email" do
        post :create, user: Fabricate.attributes_for(:user)        
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "sends the email to the correct user" do
        post :create, user: Fabricate.attributes_for(:user)        
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([User.first.email])
      end
      it "sends the correct content" do
        post :create, user: Fabricate.attributes_for(:user)        
        message = ActionMailer::Base.deliveries.last
        expect(message).to have_content("Thanks for signing up to MyFlix")  
      end
    end
    context "gets invited by a user" do
      it "creates a relationship where the invitor follows the friend" do
        invitor = Fabricate(:user)
        invite = Fabricate(:invite, user: invitor, token: 1234, friend_email: "friend@friend.com")
        post :create, user: Fabricate.attributes_for(:user, token: 1234, email: invite.friend_email)
        expect(User.first.following_relationships.first.leader).to eq(User.second)        
      end
      it "creates a relationship where the invited friend follows the invitor" do
        invitor = Fabricate(:user)
        invite = Fabricate(:invite, user: invitor, token: 1234, friend_email: "friend@friend.com")
        post :create, user: Fabricate.attributes_for(:user, token: 1234, email: invite.friend_email)
        expect(User.first.leading_relationships.first.follower).to eq(User.second)        
      end
      it "sets token to nil after use" do
        invitor = Fabricate(:user)
        invite = Fabricate(:invite, user: invitor, token: 1234, friend_email: "friend@friend.com")
        post :create, user: Fabricate.attributes_for(:user, token: 1234, email: invite.friend_email)
        expect(Invite.first.token).to eq(nil)
      end
    end
  end

  describe "GET show" do
    let(:user) {Fabricate(:user)}

    it_behaves_like "requires sign in" do
      let(:action) {get :show, id: user.id}
    end

    it "sets @user variable" do
      set_current_user
      get :show, id: user.id
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
end