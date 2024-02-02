class PointsSpent < ApplicationRecord
    has_one :user
    has_one :merchandise
end
