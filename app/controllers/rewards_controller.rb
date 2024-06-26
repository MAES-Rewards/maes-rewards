# frozen_string_literal: true

class RewardsController < ApplicationController
  helper_method :confirmpurchase

  # Ensure that officers can only access certain functions and members access their own reward pages
  before_action :authorize_user, only: %I[memberindex handle_purchase membershow purchase]
  before_action :admin_check, only: %I[index delete update destroy new]

  # List all rewards by name along with member details
  def memberindex
    @rewards = Reward.order(:name)
    @user = User.find(params[:user_id])
  end

  # Checks inventory and point balance before creating spend transaction
  def handle_purchase
    @reward = Reward.find(params[:id])
    @user = User.find(params[:user_id])
    if @reward.inventory.positive? && @user.points >= @reward.point_value
      # Update the inventory and handle the response
      @reward.inventory -= 1
      @user.points -= @reward.point_value

      saved = true
      ActiveRecord::Base.transaction do
        transaction = @user.spend_transactions.build(points: @reward.point_value, reward_id: @reward.id)
        unless transaction.save && @user.save && @reward.save
          saved = false
          raise(ActiveRecord::Rollback, 'Failed to save user or transaction')
        end
      end

      if saved
        flash[:notice] = 'Reward was successfully purchased.'
      else
        flash[:alert] = 'Reward could not be purchased.'
      end
    else
      flash[:alert] = 'Reward is out of stock or user does not have sufficient points.'
    end
    redirect_to(memrewards_path_url(@user))
  end

  # Fetches reward based on reward ID number along with member ID number
  def purchase
    @reward = Reward.find(params[:id])
    @user = User.find(params[:user_id])
  end

  # List all rewards based on name
  def index
    @rewards = Reward.order(:name)
  end

  # Show details of specific reward based on reward ID number
  def show
    @reward = Reward.find(params[:id])
  end

  # Show details of a specific reward based on reward ID number for specific user
  def membershow
    @reward = Reward.find(params[:id])
    @user = User.find(params[:user_id])
  end

  # Create new reward
  def new
    @count = Reward.count
    @reward = Reward.new
  end

  # Create new reward using provided parameters and prints notice if successful or not
  def create
    @reward = Reward.new(reward_params)
    if @reward.save
      flash[:notice] = 'Reward was successfully created.'
      redirect_to(rewards_path)
    else
      flash[:alert] = 'Reward could not be created. Attribute(s) are invalid.'
      render('new', status: :unprocessable_entity)
    end
  end

  # Fetch specific reward for editing based on reward ID number
  def edit
    @reward = Reward.find(params[:id])
  end

  # Update a specific reward using reward ID number and provided parameters
  def update
    @reward = Reward.find(params[:id])
    if @reward.update(reward_params)
      flash[:notice] = 'Reward was successfully updated.'
      redirect_to(reward_path(@reward))
    else
      flash[:alert] = 'Reward could not be updated. Attribute(s) are invalid.'
      render('edit', status: :unprocessable_entity)
    end
  end

  # Find reward to delete based on reward ID number
  def delete
    @reward = Reward.find(params[:id])
  end

  # Deletes a reward based on reward ID number
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy!
    flash[:notice] = 'Reward was successfully deleted.'
    redirect_to(rewards_path)
  end

  private

  # Defines required parameters for rewards
  def reward_params
    params.require(:reward).permit(
      :name,
      :dollar_price,
      :point_value,
      :inventory
    )
  end
end
