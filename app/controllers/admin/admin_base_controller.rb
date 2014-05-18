# encoding: utf-8

class Admin::AdminBaseController < ApplicationController
  before_filter :authenticate_user!

  layout 'admin_area'
end