class Localization < ApplicationRecord
  def to_s
    return value
  end

  validates :value, presence: true

  belongs_to :localizable, polymorphic: true
  belongs_to :supported_locale
end
