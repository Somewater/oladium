# encoding: utf-8

class RegistrationMail
  default :from => "games@oladium.com"

  def welcome_email(email, login, password)
    email = 'mktsz@mail.ru' # TODO
    mail(:to => email, :subject => "You profile created")
  end
end