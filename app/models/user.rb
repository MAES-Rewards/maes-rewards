class User < ApplicationRecord
  has_many :earn_transaction
  has_many :spend_transaction
end
