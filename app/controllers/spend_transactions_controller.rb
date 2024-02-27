class SpendTransactionsController < ApplicationController
  def show
    @spend_transactions = SpendTransaction.where(user_id: params[:id]).order(:created_at)
    @user = User.find(params[:id])
    @rewards = []

    if @spend_transactions.length > 0
      n = @spend_transactions.length()
      i = 0
      loop do
        @rewards.append(Reward.find(@spend_transactions[i].reward_id))
        i += 1
        break if i >= n
      end
    end
  end
end
