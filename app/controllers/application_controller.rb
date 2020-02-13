require 'best_language'
require 'i18n_debug'

class ApplicationController < ActionController::Base
  include Pundit
  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect
  # before the location can be stored.

  before_action :set_supported_locales
  around_action :set_locale
  around_action :set_i18n_debug

  def default_url_options
    options = { locale: I18n.locale.to_s.downcase }

    # Persist i18n debugging.
    if params.has_key?(:i18n)
      options["i18n"] = 1
    end

    return options
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

    def set_supported_locales
      @supported_locales = SupportedLocale.all
    end

    def set_locale(&action)
      locale = BestLanguage.get_best_language(
        I18n.available_locales,
        params[:locale],
        request.env['HTTP_ACCEPT_LANGUAGE'],
        I18n.default_locale
      )
      @active_locale = @supported_locales.find {|supported_locale| supported_locale.name.downcase == locale.downcase }
      I18n.with_locale(locale, &action)
    end

    def set_i18n_debug(&action)
      if params.has_key?(:i18n)
        I18nDebug.with_backend(I18nDebugBackend.new, &action)
      else
        I18nDebug.with_backend(I18n.backend, &action)
      end
    end

    def initialize
      # Counter that is reset per request.
      @unique_id = 0
      super()
    end
end
