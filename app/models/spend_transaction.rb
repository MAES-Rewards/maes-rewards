# frozen_string_literal: true

class SpendTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :reward
  # has_one :user, dependent: :destroy
  # has_one :reward, dependent: :destroy
end
