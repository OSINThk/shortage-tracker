class Privilege < ApplicationRecord
  has_and_belongs_to_many :role
end
