# frozen_string_literal: true

class RewardsController < ApplicationController
  helper_method :confirmpurchase
  before_action :authorize_user, only: %I[memberindex handle_purchase membershow purchase]

  def memberindex
    @rewards = Reward.order(:name)
    @user = User.find(params[:user_id])
  end

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
        unless transaction.save && @user.save
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

  def purchase
    @reward = Reward.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def index
    @rewards = Reward.order(:name)
  end

  def show
    @reward = Reward.find(params[:id])
  end

  def membershow
    @reward = Reward.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def new
    @count = Reward.count
    @reward = Reward.new
  end

  def create
    @reward = Reward.new(reward_params)
    if @reward.save
      flash[:notice] = 'Reward was successfully created.'
      redirect_to(rewards_path)
    else
      puts("Errors: #{@reward.errors.full_messages}") # rubocop:disable Rails/Output
      flash[:alert] = 'Reward could not be created. Attribute(s) are invalid.'
      render('new', status: :unprocessable_entity)
    end
  end

  def edit
    @reward = Reward.find(params[:id])
  end

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

  def delete
    @reward = Reward.find(params[:id])
  end

  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy!
    flash[:notice] = 'Reward was successfully deleted.'
    redirect_to(rewards_path)
  end

  private

  def reward_params
    params.require(:reward).permit(
      :name,
      :dollar_price,
      :point_value,
      :inventory
    )
  end
end
