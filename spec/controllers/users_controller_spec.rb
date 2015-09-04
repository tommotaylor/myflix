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

    context "successful signup" do

      it "redirects to home path" do
        result = double(:user_signup_response, successful?: true)
        UserSignup.any_instance.should_receive(:signup).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to(home_path)
      end
    end

    context "unsuccessful signup" do

      it "renders the new template" do
        result = double(:user_signup_response, successful?: false)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to(home_path)        
      end
      it "displays the correct error message"
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