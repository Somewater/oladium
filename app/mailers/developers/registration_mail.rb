# encoding: utf-8

class Developers::RegistrationMail < ActionMailer::Base
  default :from => "games@oladium.com"

  def welcome_email(email, login, password)
    @login = login
    @password = password
    mail(:to => email, :subject => "Your profile has been created") do |format|
     format.html { render "developers/mailer/welcome_email" }
   end
  end

  def profile_ready_email(email, login, password, sig)
    @login = login
    @password = password
    @sig = sig
    mail(:to => email, :subject => "Your profile is ready") do |format|
      format.html { render "developers/mailer/profile_ready_email" }
    end
  end
end
