class AppMailer < ActionMailer::Base

  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: 'info@myflix.com', subject: 'Welcome to Myflix'
  end

  def send_forgot_password_email(user)
    @user = user
    mail to: user.email, from: 'info@myflix.com', subject: 'Forgot password'
  end

  def send_invitation_email(user, invitation)
    @invitation = invitation
    @inviter = user
    mail to: invitation.recipient_email, from: 'info@myflix.com', subject: 'MyFlix Invitation'
  end
end
