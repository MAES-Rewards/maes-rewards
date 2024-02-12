# frozen_string_literal: true

class Reward < ApplicationRecord
  has_many :spend_transaction, dependent: :nil
  validates :name, presence: true
  validates :dollar_price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }
  validates :point_value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }
  validates :inventory, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }
end
