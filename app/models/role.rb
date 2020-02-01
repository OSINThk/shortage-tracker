class Role < ApplicationRecord
  def to_s
    return name
  end

  has_and_belongs_to_many :privilege
  has_and_belongs_to_many :user
end
