class Dyne < ApplicationRecord
  has_many :lessons
  belongs_to :unit
end
