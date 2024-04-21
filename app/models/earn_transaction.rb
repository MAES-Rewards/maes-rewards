# frozen_string_literal: true

class EarnTransaction < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :activity, optional: true
  # has_one :user, dependent: :destroy
  # has_one :activity, dependent: :destroy
end
