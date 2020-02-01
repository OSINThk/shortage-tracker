class ProductDetail < ApplicationRecord
  belongs_to :product
  belongs_to :report

  validates :price, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
  validates :scarcity, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
end
