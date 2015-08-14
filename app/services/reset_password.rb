class ResetPassword

  def initialize(user)
    user.password_reset_token = SecureRandom.urlsafe_base64
    user.password_reset_sent_at = Time.now
    user.save!
    AppMailer.reset_password(user).deliver
  end
end