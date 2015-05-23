require 'rails_helper'

describe VideosController do
  describe "GET show"  do
    it "assigns the requested video to @video when signed in" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    it "redirects user to login if not signed in" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to(:sign_in)
    end
  end
  describe "GET search" do
    it "assigns @results when signed in" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :search, search_term: "#{video.title}"
      expect(assigns(:results)).to eq([video])
    end
    it "redirects user to login if not signed in" do
      video = Fabricate(:video)
      get :search, search_term: "#{video.title}"
      expect(response).to redirect_to(:sign_in)
    end
  end
end