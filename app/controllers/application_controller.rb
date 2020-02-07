class ApplicationController < ActionController::Base
  before_action :set_locale
  include Pundit
  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect
  # before the location can be stored.

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def browser_locale(request)
   locales = request.env['HTTP_ACCEPT_LANGUAGE'] || ""
   locales.scan(/[a-z]{2}(?=;)/).find do |locale|
     I18n.available_locales.include?(locale.to_sym)
   end
  end
    
  private
    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
    #    infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behaviour.
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
    end

    def initialize
      # Counter that is reset per request.
      @unique_id = 0
      super()
    end
end
