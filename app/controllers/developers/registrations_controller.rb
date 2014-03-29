# encoding: utf-8

class Developers::RegistrationsController < Devise::RegistrationsController
  def new
    if signed_developer
      super
    else
      render 'developers/sessions/error'
    end
  end

  def create
    if signed_developer
      super
      unless resource.new_record?
        RegistrationMail.welcome_email(resource_params[:email], params[:login], resource_params[:password]).deliver
      end
    else
      render 'developers/sessions/error'
    end
  end

  protected

  def build_resource
    if signed_developer
      self.resource = signed_developer
    else
      super
    end
  end

  def signed_developer
    return @_signed_developer if defined? @_signed_developer
    if params[:login].present? && params[:sig].present?
      developer = resource_class.where(login: params[:login]).first
      if developer.sig == params[:sig]
        @_signed_developer = developer
        return developer
      end
    end
    @_signed_developer = false
    false
  end
end