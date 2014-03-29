# encoding: utf-8

class Developers::ProfilesController < ApplicationController
  before_filter :authenticate_developer!

  def index
    render :text => 'index'
  end

  def show
    render :text => 'show'
  end
end