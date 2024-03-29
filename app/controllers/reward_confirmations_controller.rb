class RewardConfirmationsController < ApplicationController
  before_action :admin_check, only: %I[index update]
  before_action :set_reward_confirmation, only: [:update]

  def index
    @recent_purchases = SpendTransaction.includes(:reward, :user, :reward_confirmation).where('created_at >= ?', 24.hours.ago).order(created_at: :desc)

  end

  def update
    if @reward_confirmation.update(reward_confirmation_params)
        respond_to do |format|
          format.html { redirect_to reward_confirmations_path, notice: 'Status Updated.' }
        end
      else
        redirect_to reward_confirmations_path, alert: 'Reward Confirmation Error.'
      end
  end

  private

  def set_reward_confirmation
    @reward_confirmation = RewardConfirmation.find_by(id: params[:id])
    if @reward_confirmation.nil?
        redirect_to reward_confirmations_path, alert: "Error."
    end
  end

  def reward_confirmation_params
    params.require(:reward_confirmation).permit(:reward_given)
  end
end
