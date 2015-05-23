require 'rails_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user if not signed in" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
    it "redirects to home if signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
  end
  describe "POST create" do
    it "creates a new user and redirects to home if validations met" do
      post :create, user: Fabricate(:user)
      expect(assigns(:user)).to be_new_record(User)
      expect(response).to redirect_to(home_path)
    end
    it "doesn't create user and renders new if validations not met" do
      post :create, user: Fabricate(:user, name: "")
      expect(response).to redirect_to(new_user_path)
    end
  end
end