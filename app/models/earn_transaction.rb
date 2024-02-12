# frozen_string_literal: true

class EarnTransaction < ApplicationRecord
  has_one :user, dependent: :nil
  has_one :activity, dependent: :nil
end
