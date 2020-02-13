require_relative './accept_language'
require_relative './locale'

class BestLanguage
  def self.get_best_language(available_locales, param, header, default_locale)
    if !param.nil?
      return Locale.from_rfc5646(param).rfc5646
    end

    # See if there are matches in the Accept-Language header.
    header_values = AcceptLanguage::Header.parse(header)
    header_values.each do |value|
      if value.check?(available_locales)
        return value.locale.rfc5646
      end
    end

    return Locale.from_rfc5646(default_locale.to_s).rfc5646
  end
end
