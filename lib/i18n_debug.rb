class I18nDebug
  def self.with_backend(tmp_backend = nil)
    if tmp_backend == nil
      yield
    else
      current_backend = I18n.backend
      I18n.backend = tmp_backend
      begin
        yield
      ensure
        I18n.backend = current_backend
      end
    end
  end
end

class I18nDebugBackend < I18n::Backend::Simple
  def translate(locale, key, *args)
    return key
  end
end
