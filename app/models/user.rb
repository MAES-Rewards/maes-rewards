# frozen_string_literal: true

class User < ApplicationRecord
  has_many :earn_transactions, dependent: :nullify
  has_many :spend_transactions, dependent: :nullify
  validates :name, presence: true
  # add formatting validation later
  validates :email, presence: true
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2_147_483_647 }

  def self.create_with_default_stats(admin:)
    create!(
      name: admin.full_name,
      email: admin.email,
      points: 0,
      is_admin: false
    )
  end
end
