class Product < ApplicationRecord
  def to_s
    return name
  end

  has_many :product_details
end
