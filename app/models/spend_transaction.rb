# frozen_string_literal: true

class SpendTransaction < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :reward, optional: true
  has_one :reward_confirmation, dependent: :destroy
  # has_one :user, dependent: :destroy
  # has_one :reward, dependent: :destroy

  after_create :create_reward_confirmation

  private

  def create_reward_confirmation
    build_reward_confirmation.save!
  end
end
