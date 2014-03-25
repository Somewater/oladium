# encoding: utf-8

class TmpDevelopersController < ApplicationController
  def index
    if params[:login].present? && params[:sig].present?
      @developer = Developer.where(:login => params[:login]).first
      if @developer && @developer.sig == params[:sig]
        if params[:email].present?
          @developer.update_column :email, params[:email]
          flash.now.notice = "Your email is saved. You will be notified"
        end
        render 'index'
        return
      end
    end
    render 'error'
  end
end