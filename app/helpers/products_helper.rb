module ProductsHelper
  def find_localization(product, supported_locale)
    product.localization.find {|localization| localization.supported_locale_id == supported_locale.id }
  end

  def localization_hash(product)
    output = {}

    product.localization.each do |localization|
      output[localization.supported_locale.name] = localization.value
    end

    return output
  end
end
