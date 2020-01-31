class Role < ApplicationRecord
  has_and_belongs_to_many :privilege
  has_and_belongs_to_many :user
end
