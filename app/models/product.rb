class Product < ApplicationRecord
  def to_s
    return name
  end

  validates :name, presence: true

  has_many :product_details
end
