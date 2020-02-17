require_relative './locale'

PIECES = /(?:^|,| )([A-Za-z\-\*]+)(?:(?:;q=)?(\.[0-9]+|0\.[0-9]+|0|1))?(?=$|,| )/

module Enumerable
  def stable_sort
    sort_by.with_index { |x, idx| [x, idx] }
  end

  def stable_sort_by
    sort_by.with_index { |x, idx| [yield(x), idx] }
  end
end

# Usage
# require 'accept_language'
# header = AcceptLanguage::Header.parse(request.env['HTTP_ACCEPT_LANGUAGE'])

module AcceptLanguage
  class Value
    attr_reader :quality
    attr_reader :locale

    def initialize(locale, quality)
      if locale != "*"
        @locale = Locale.from_rfc5646(locale)
      else
        @locale = "*"
      end

      quality = quality.nil? ? 1.0 : quality.to_f

      if quality > 1
        quality = 1.0
      end

      if quality < 0
        quality = 0.0
      end

      @quality = quality
    end

    def <=>(other)
      case other
        when Value
          if @quality < other.quality
            return 1
          end
          if @quality == other.quality
            return 0
          end
          if @quality > other.quality
            return -1
          end
        else
          nil
      end
    end

    def check?(available_locales)
      available_locales.each do |locale|
        # TODO: normalize.
        if @locale.rfc5646 == locale.to_s
          return true
        end
      end

      return false
    end

    def to_s
      output = @locale.is_a?(Locale) ? @locale.rfc5646 : @locale
      return "#{output};q=#{@quality}"
    end
  end

  class Header
    attr_reader :values

    def initialize(values)
      @values = values.stable_sort()
    end

    def self.parse(header_string)
      values = []

      if header_string.is_a?(String)
        header_string.scan(PIECES).each do |match|
          locale, quality = match
          values << Value.new(locale, quality)
        end
      end

      return Header.new(values)
    end

    def each(&block)
      @values.each do |value|
        # Stop iterating before processing "*".
        # We want to proceed to the default in this scenario.
        if (value.locale == "*")
          return
        end

        block.call(value)
      end
    end
  end
end
