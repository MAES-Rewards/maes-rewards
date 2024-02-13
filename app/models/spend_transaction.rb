# frozen_string_literal: true

class SpendTransaction < ApplicationRecord
  has_one :user, dependent: :destroy
  has_one :reward, dependent: :destroy
end
