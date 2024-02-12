class User < ApplicationRecord
  # has_many :earn_transaction
  # has_many :spend_transaction
  validates :name, presence: true
  validates :email, presence: true # add formatting validation later
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }
end
