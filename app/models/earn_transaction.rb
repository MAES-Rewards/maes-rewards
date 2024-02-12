# frozen_string_literal: true

class EarnTransaction < ApplicationRecord
  has_one :user
  has_one :activity
end
