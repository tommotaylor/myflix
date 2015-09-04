class Invitation

  def initialize(invite_params, current_user)
    @invite = Invite.new(invite_params)
    @invite.user = current_user
  end
 
  def friend_is_member?
    if User.find_by(email: @invite.friend_email)
      true
    else
      false
    end
  end

  def send_invite(invite)
    invite.token = SecureRandom.urlsafe_base64
    invite.invite_sent_at = Time.now
    invite.save!
    AppMailer.delay.send_invite_email(invite)
  end
end