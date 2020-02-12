class Localization < ApplicationRecord
  belongs_to :localizable, polymorphic: true
  belongs_to :supported_locale
end
