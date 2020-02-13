json.extract! product, :id
json.name find_localization(product, @active_locale).value
