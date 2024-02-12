# frozen_string_literal: true

class SpendTransaction < ApplicationRecord
  has_one :user, dependent: :nil
  has_one :reward, dependent: :nil
end
