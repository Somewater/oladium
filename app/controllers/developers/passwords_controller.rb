# encoding: utf-8

class Developers::PasswordsController < Devise::PasswordsController
  def new
    flash.now.notice = t('developers.sing_in_notice').html_safe
    super
  end
end