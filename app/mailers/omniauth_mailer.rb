class OmniauthMailer < ApplicationMailer
  default from: 'thinknetica-dev@example.com'

  def finish_signup_email(id, email)
    @id = id
    @email = email
    mail(to: @email, subject: 'Email confirmation')
  end
end
