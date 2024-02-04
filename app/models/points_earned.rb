class PointsEarned < ApplicationRecord
    has_one :user
    has_one :point_source
end
