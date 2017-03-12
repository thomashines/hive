class Unit < ApplicationRecord
  has_many :dynes
  belongs_to :course
  has_many :lessons, through: :dynes
end
