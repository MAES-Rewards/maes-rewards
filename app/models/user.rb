class User < ApplicationRecord
    has_many :point_spent
    has_many :points_earned 
end
