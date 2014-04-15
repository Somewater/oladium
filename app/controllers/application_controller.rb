class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def developer_root_path
    developer_path
  end

  protected
  def set_locale
    @locale = params[:locale]
    @locale = request.host.split('.').last unless @locale
    @locale = I18n.default_locale unless @locale && @locale =~ /^(en|ru)$/
    I18n.locale = @locale
  end

  def assign_page()
    @page = [params[:page].to_i - 1, 0].max
    @page
  end
end
