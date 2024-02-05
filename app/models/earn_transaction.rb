class EarnTransaction < ApplicationRecord
  has_one :user
  has_one :activity
end
