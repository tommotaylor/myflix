require "rails_helper"

describe SessionsController do
  describe "GET new" do
    it "redirects to home if signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
    it "renders sign in page if not signed in" do
      get :new
      expect(response).to render_template(:new)
    end
  end
  describe "POST create" do
    context "correct credentials" do
      it "creates a new session" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end
      it "redirects to home" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to(home_path)
      end
    end
    context "incorrect credentials" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email + "x", password: user.password
      end
      it "doesn't create a new session" do
        expect(session[:user_id]).to be_nil
      end
      it "redirect to the sign in page" do
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
       get :destroy
    end
    it "deletes session" do
      expect(session[:user_id]).to be_nil
    end
    it "redirects to front page" do
      expect(response).to redirect_to(front_path)
    end
    it "flashes signed out notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end