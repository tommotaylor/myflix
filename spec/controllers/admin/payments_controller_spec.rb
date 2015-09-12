require 'rails_helper'

describe Admin::PaymentsController do
  
  describe "GET index" do

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "sets the @payments variable" do
      set_current_admin
      payment = Fabricate(:payment)
      get :index
      expect(assigns(:payments)).to include(payment)
    end

    it "renders the index template" do
      set_current_admin
      get :index
      expect(response).to render_template(:index)
    end

    it "redirects to home for the non admin user" do
      set_current_user
      get :index
      expect(response).to redirect_to home_path
    end

    it "flashes the error to the non admin user" do
      set_current_user
      get :index
      expect(flash[:error]).to be_present      
    end
  end
end