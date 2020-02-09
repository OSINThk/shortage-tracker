require 'accept_language'
require 'locale'
require 'i18n_debug'

class ApplicationController < ActionController::Base
  include Pundit
  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect
  # before the location can be stored.

  around_action :set_locale
  around_action :set_i18n_debug

  def default_url_options
    { locale: I18n.locale }
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

    def set_locale(&action)
      I18n.with_locale(get_best_language, &action)
    end

    def set_i18n_debug(&action)
      if params.has_key?(:i18n)
        I18nDebug.with_backend(I18nDebugBackend.new, &action)
      else
        I18nDebug.with_backend(I18n.backend, &action)
      end
    end

    def get_best_language
      if !params[:locale].nil?
        return Locale.from_rfc5646(params[:locale]).rfc5646
      end

      # TODO: See if there are matches in the Accept-Language header.
      header_locales = AcceptLanguage::Header.parse(request.env['HTTP_ACCEPT_LANGUAGE'])

      return Locale.from_rfc5646(I18n.default_locale.to_s).rfc5646
    end

    def initialize
      # Counter that is reset per request.
      @unique_id = 0
      super()
    end
end
