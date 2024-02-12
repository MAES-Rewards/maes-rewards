class Activity < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :default_points, presence: true, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647
  }
end
