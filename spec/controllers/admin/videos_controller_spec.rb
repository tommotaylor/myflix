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
end