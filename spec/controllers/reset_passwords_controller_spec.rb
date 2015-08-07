require 'rails_helper'

describe ResetPasswordsController do
  describe "POST create" do
    context "valid email address" do
      it "sends an email to the email address entered" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end
      it "sets the reset password token for the user" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, email: user.email
        expect(User.first.password_reset_token).to be_present
      end
      it "timestamps the password reset token for the user" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, email: user.email
        expect(User.first.password_reset_sent_at).to be_present
      end
      it "puts the correct link and token in the email"
      it "redirects to the confirm_password_reset page" 
    end
    context "invalid inputs" do
      it "doesn't set token or sent at timestamp" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, email: "incorrect@gmail.com"
        expect(User.first.password_reset_sent_at).not_to be_present
        expect(User.first.password_reset_token).not_to be_present

      end
      it "redirects to the confirmation page" do
        user = Fabricate(:user)
        set_current_user(user)
        post :create, email: "incorrect@gmail.com"
        expect(response).to redirect_to(confirm_password_reset_path)
      end
    end
  end

  describe "GET edit" do
    it "finds and sets the correct @user variable" do
      binding.pry
      user = Fabricate(:user)
      session[:user_id] = user.id
      post :create, email: user.email
      get :edit, id: User.first.password_reset_token
      binding.pry
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "POST update" do
    it "updates the password"
    it "doesn't update if password_reset_token_set_at was more than 2 hours ago"
  end
end