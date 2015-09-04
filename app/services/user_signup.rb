class UserSignup
  
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def signup(options={})
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :source => options[:stripeToken]
        )
      if charge.successful?
        @user.save
        AppMailer.welcome_email(@user).deliver
        if options[:invite_token]
          handle_invited_user(options[:invite_token])
          @status = :successful
          self
        else
          @status = :successful
          self
        end
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Please fill out all user fields"
      self
    end
  end

  def successful?
    @status == :successful
  end

private

  def handle_invited_user(invite_token)
    invite = Invite.find_by(token: invite_token)
    @user.follow(invite.user)
    invite.user.follow(@user)
    invite.update_attributes!(token: nil)
  end
end