require_relative 'boot'

require 'rails/all'
require './lib/rack_locale'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShortageTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.redis = config_for(:redis)

    config.i18n.default_locale = "en"
    config.i18n.available_locales = [
      "en"
    ]

    # Make sure to set locale before exceptions are handled.
    config.middleware.insert_before(
      ActionDispatch::ShowExceptions,
      RackLocale,
      config.i18n.available_locales
    )

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
