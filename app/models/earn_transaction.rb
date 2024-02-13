# frozen_string_literal: true

class EarnTransaction < ApplicationRecord
  has_one :user, dependent: :destroy
  has_one :activity, dependent: :destroy
end
