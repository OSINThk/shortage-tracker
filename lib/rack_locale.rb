require 'i18n'
require_relative './locale'
require_relative './best_language'

class RackLocale
  def initialize(app, available_locales)
    @app = app
    @locale_segment = Regexp.new("^\/(#{available_locales.join('|').downcase})(?:\/|$)")
  end

  def call(env)
    request = Rack::Request.new(env)

    # This only sets the locale for the Rack middlewares that come after it.
    # It uses the same method the main application uses for consistency.

    matches = @locale_segment.match(request.path)
    param = nil
    if (!matches.nil?)
      param = matches[1]
    end

    locale = BestLanguage.get_best_language(
      I18n.available_locales,
      param,
      request.env['HTTP_ACCEPT_LANGUAGE'],
      I18n.default_locale
    )
    I18n.locale = locale

    @app.call(env)
  end
end
