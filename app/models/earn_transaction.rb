# frozen_string_literal: true

class EarnTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  #has_one :user, dependent: :destroy
  #has_one :activity, dependent: :destroy
end
