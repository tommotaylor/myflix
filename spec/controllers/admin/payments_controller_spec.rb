require 'rails_helper'

describe Admin::PaymentsController do
  
  describe "GET index" do

    it "redirects non admin users to home"
    it "flashes an error to non-admin users"

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
  end
end