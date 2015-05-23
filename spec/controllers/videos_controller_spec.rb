require 'rails_helper'

describe VideosController do

  describe "GET show"  do
    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user)
      end
      it "assigns the requested video to @video" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      it "renders the show template" do
        video = Fabricate(:video)
        get :show, id: video
        expect(response).to render_template(:show)
      end
    end
  end

  describe "GET search" do
    it "assigns @results"
    it "renders the search template"
  end
end