class Report < ApplicationRecord
  def long
    return "#{coordinates.lon}"
  end

  def lat
    return "#{coordinates.lat}"
  end

  validate :coordinates_valid
  validates :user, presence: true

  belongs_to :user

  has_many :product_detail, dependent: :destroy
  accepts_nested_attributes_for :product_detail, allow_destroy: true

  validates_presence_of :product_detail
  validates_associated :product_detail, forward_validation_context: true
  validate :product_detail_valid

  private
    def product_detail_valid
      product_details_count = product_detail.length
      unique_count = product_detail.map { |detail| detail.product_id }.uniq

      if product_details_count > 1 && product_details_count != unique_count
        errors.add(:product_detail, "You may not provide duplicate details for the same product.")
      end
    end

    def coordinates_valid
      # Coordinate will be `nil` already if invalid.
      # Error message is vague because it could be unentered, or invalid.
      if coordinates.nil?
        errors.add(:coordinates, "Please reenter location coordinate.")
        return
      end

      # RGeo will happily parse a MULTIPOINT or any other valid WKT.
      # Make sure we have a POINT.
      if RGeo::Feature::Point != coordinates.geometry_type
        errors.add(:coordinates, "Location coordinate must be a single point.")
        return
      end
    end
end
