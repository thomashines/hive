class Lesson < ApplicationRecord
  belongs_to :dyne
  has_one :unit, through: :dyne
end
