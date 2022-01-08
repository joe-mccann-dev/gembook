class UserMailer < ApplicationMailer
  default from: "joe.mccann.dev@gmail.com"

  def welcome_email(user)
    @user = user
    @url  = user_url(user)
    mail(to: @user.email, subject: 'Welcome to Gembook.')
  end
end
