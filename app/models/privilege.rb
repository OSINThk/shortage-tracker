class Privilege < ApplicationRecord
  def to_s
    return name
  end

  has_and_belongs_to_many :role
end
