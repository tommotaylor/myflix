class AppMailer < ActionMailer::Base
  def welcome_email(user)
    mail from: 'info@myflix.com', to: user.email, subject: 'Thanks for registering for MyFlix'
  end

  def reset_password(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: 'Your password reset link'
  end
end