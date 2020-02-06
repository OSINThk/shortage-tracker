class ApplicationController < ActionController::Base
  before_action :set_locale
  include Pundit

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
  
  private
    def initialize
      # Counter that is reset per request.
      @unique_id = 0
      super()
    end
end
