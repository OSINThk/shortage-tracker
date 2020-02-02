class Privilege < ApplicationRecord
  def to_s
    return name
  end

  validates :name, presence: true

  has_and_belongs_to_many :role
end
