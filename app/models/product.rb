class Product < ApplicationRecord
  def to_s
    return name
  end

  validates :name, presence: true

  has_many :product_detail
  has_many :localization, as: :localizable

  accepts_nested_attributes_for :localization
end
