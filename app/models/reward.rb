class Reward < ApplicationRecord
  has_many :spend_transaction
  validates :name, presence: true
  validates :dollar_price, presence: true
  validates :point_value, presence: true
  validates :inventory, presence: true
end
