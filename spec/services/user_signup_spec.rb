require 'rails_helper'

describe UserSignup do

  describe ".signup" do

    context "correct user and correct card info" do
      
      let(:charge) { double(:charge, successful?: true) }
      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end
      after(:each) { ActionMailer::Base.deliveries.clear }

      it "creates a new user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end
        
      it "sends an email" do
        post :create, user: Fabricate.attributes_for(:user)        
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends the email to the correct user" do
        post :create, user: Fabricate.attributes_for(:user)        
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([User.first.email])
      end

      it "sends the correct content" do
        post :create, user: Fabricate.attributes_for(:user)        
        message = ActionMailer::Base.deliveries.last
        expect(message).to have_content("Thanks for signing up to MyFlix")  
      end

       context "gets invited by a user" do

        it "creates a relationship where the invitor follows the friend" do
          invitor = Fabricate(:user)
          invite = Fabricate(:invite, user: invitor, token: 1234, friend_email: "friend@friend.com")
          post :create, user: Fabricate.attributes_for(:user, token: 1234, email: invite.friend_email)
          expect(User.first.following_relationships.first.leader).to eq(User.second)        
        end

        it "creates a relationship where the invited friend follows the invitor" do
          invitor = Fabricate(:user)
          invite = Fabricate(:invite, user: invitor, token: 1234, friend_email: "friend@friend.com")
          post :create, user: Fabricate.attributes_for(:user, token: 1234, email: invite.friend_email)
          expect(User.first.leading_relationships.first.follower).to eq(User.second)        
        end
        
        it "sets token to nil after use" do
          invitor = Fabricate(:user)
          invite = Fabricate(:invite, user: invitor, token: 1234, friend_email: "friend@friend.com")
          post :create, user: Fabricate.attributes_for(:user, token: 1234, email: invite.friend_email)
          expect(Invite.first.token).to eq(nil)
        end
      end
    end

    context "with invalid user info" do

      before do 
        post :create, user: Fabricate.attributes_for(:user, email: "")
      end

      it "doesn't charge the card" do
        expect(StripeWrapper::Charge).to_not receive(:create)
      end
    
      it "doesn't create a new user" do
        expect(User.count).to eq(0)
      end
    
      it "renders :new" do
        expect(response).to render_template(:new)
      end
    end

    context "with valid user but declined card" do

      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined") }
      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end

      it "doesn't create a new user" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(response).to render_template(:new)
      end

      it "sets the flash error message" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
        expect(flash[:error]).to eq("Your card was declined")
      end
    end
  end
end