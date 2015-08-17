class AppMailer < ActionMailer::Base
  def welcome_email(user)
    mail from: 'info@myflix.com', to: user.email, subject: 'Thanks for registering for MyFlix'
  end

  def reset_password(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: 'Your password reset link'
  end

  def send_invite_email(invite)
    @invite = invite
    mail from: 'info@myflix.com', to: invite.friend_email, subject: '#{@invite.user.name} has invited you to join MyFlix'
  end
end