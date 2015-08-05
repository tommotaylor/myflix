class AppMailer < ActionMailer::Base
  def welcome_email(user)
    mail from: 'info@myflix.com', to: user.email, subject: 'Thanks for registering for MyFlix'
  end
end