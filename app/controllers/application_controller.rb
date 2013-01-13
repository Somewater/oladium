class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  protected
	def set_locale
		@locale = params[:locale]
		@locale = cookies[:locale] unless @locale
    @locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if !@locale && request.env['HTTP_ACCEPT_LANGUAGE']
    @locale = request.host.split('.').last unless @locale
    @locale = I18n.default_locale unless @locale && @locale =~ /^(en)$/
		cookies[:locale] = @locale unless cookies[:locale] && cookies[:locale] == @locale.to_s
		I18n.locale = @locale
  end
end
