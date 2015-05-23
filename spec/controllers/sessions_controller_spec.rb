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
    it "creates a new session and redirects to home if credentials correct"
    it "doesn't create a new session and renders the sign in page if credentials incorrect"
  end
  describe "GET destroy" do
    it "deletes session and redirects to front" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be(nil)
    end
  end
end