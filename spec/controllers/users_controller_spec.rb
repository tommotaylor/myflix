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
  end

  describe "GET show" do
    let(:user) {Fabricate(:user)}
    before do
      session[:user_id] = user.id
    end
    it "sets @user variable" do
      get :show, id: user.id
      expect(assigns(:user)).to be_instance_of(User)
    end
    it "renders :show" do
      get :show, id: user.id
      expect(response).to render_template(:show)
    end
  end
end