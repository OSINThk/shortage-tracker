class SupportedLocale < ApplicationRecord
  def to_s
    return name
  end

  validates :name, presence: true
  has_many :localization
end
