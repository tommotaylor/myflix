require 'rails_helper'

describe Admin::VideosController do
  
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
    it "sets the @video variable" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
    end
    it "redirects to home for the non admin user" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
    it "flashes the error to the non admin user" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present      
    end
  end

  describe "POST create" do
    context "not signed in as admin" do
      it_behaves_like "requires sign in" do
        let(:action) { post :create }
      end
    end

    context "signed in as admin" do
      context "if validations met" do
        it "sets the @video variable" do
          set_current_admin
          post :create, video: Fabricate.attributes_for(:video)
          expect(assigns(:video)).to be_instance_of(Video)
        end
        it "redirects to the video page" do
          set_current_admin
          post :create, video: Fabricate.attributes_for(:video)
          expect(response).to redirect_to Video.first
        end
        it "saves the video" do
          set_current_admin
          category = Fabricate(:category)
          post :create, video: Fabricate.attributes_for(:video, category: category, title: "Mad Max")
          expect(Video.first.title).to eq("Mad Max")
          expect(Video.first.category).to eq(category)
        end
      end
      context "if validations not met" do
        it "doesn't save the video" do
          set_current_admin
          category = Fabricate(:category)
          post :create, video: Fabricate.attributes_for(:video, category: category, title: "")
          expect(Video.count).to eq(0)
        end
        it "renders the new page" do
          set_current_admin
          category = Fabricate(:category)          
          post :create, video: Fabricate.attributes_for(:video, category: category, description: "")
          expect(response).to render_template(:new)
        end
        it "flashes an error message" do
          set_current_admin
          category = Fabricate(:category)          
          post :create, video: Fabricate.attributes_for(:video, category: category, title: "")
          expect(flash[:error]).to be_present
        end
      end
    end
  end
end