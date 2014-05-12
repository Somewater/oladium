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

  def assign_page()                       6
    @page = [params[:page].to_i - 1, 0].max
    @page
  end

  def update_with_bip(scope, model_params = nil, model_id = nil, &block)
    model_id ||= params[:id]
    @model = if block_given?
               model_params = scope
               block.call(model_id)
             else
               scope.find(model_id)
             end

    respond_to do |format|
      @model.update_attributes(model_params)
      format.json { respond_with_bip(@model) }
    end
  end
end
