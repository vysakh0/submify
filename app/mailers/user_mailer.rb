class UserMailer < ActionMailer::Base
  default from: "support@submify.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
  def confirmation(user)
    @user = user
    mail :to => user.email, :subject => "Confirm to activate your account"
  end
end
