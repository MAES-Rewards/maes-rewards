# frozen_string_literal: true

class RewardConfirmation < ApplicationRecord
  belongs_to :spend_transaction
end
