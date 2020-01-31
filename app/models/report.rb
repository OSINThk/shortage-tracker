class Report < ApplicationRecord
  validate :coordinates_valid
  validates :user, presence: true

  belongs_to :user

  private
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
