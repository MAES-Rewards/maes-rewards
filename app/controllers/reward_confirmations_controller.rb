# frozen_string_literal: true

class RewardConfirmationsController < ApplicationController
  # Ensure that only officers can access certain notification functionalities
  before_action :admin_check, only: %I[index update]
  before_action :set_reward_confirmation, only: [:update]

  # List reward purchases in the past 24 hours
  def index
    @recent_purchases = SpendTransaction.includes(:reward, :user, :reward_confirmation)
                                        .where('created_at >= ?', 24.hours.ago).order(created_at: :desc)
  end

  # Update status of reward purchase based on if the officer clicks the checkbox or not
  def update
    if @reward_confirmation.update(reward_confirmation_params)
      respond_to do |format|
        format.html { redirect_to(reward_confirmations_path, notice: 'Status Updated.') }
      end
    else
      redirect_to(reward_confirmations_path, alert: 'Reward Confirmation Error.')
    end
  end

  private

  # Redirect back to reward notifications page if purchase isn't found
  def set_reward_confirmation
    @reward_confirmation = RewardConfirmation.find_by(id: params[:id])
    redirect_to(reward_confirmations_path, alert: 'Error.') if @reward_confirmation.nil?
  end

  # Require specific parameters for reward confirmations (boolean reward_given value)
  def reward_confirmation_params
    params.require(:reward_confirmation).permit(:reward_given)
  end
end
