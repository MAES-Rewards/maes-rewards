class RewardsController < ApplicationController
  helper_method :confirmpurchase

  def memberindex
    @rewards = Reward.order(:name)
  end

  def handle_purchase
    @reward = Reward.find(params[:id])
    if @reward.inventory > 0
      # Update the inventory and handle the response
      @reward.inventory -= 1
      if @reward.save
        flash[:notice] = 'Reward was successfully purchased.'
      else
        flash[:alert] = 'Reward could not be purchased.'
      end
    else
      flash[:alert] = 'Reward is out of stock.'
    end
    redirect_to(members_path_url)
  end

  def purchase
    @reward = Reward.find(params[:id])
  end

  def index
    @rewards = Reward.order(:name)
  end

  def show
    @reward = Reward.find(params[:id])
  end

  def new
    @count = Reward.count
    @reward = Reward.new
  end

  def create # rubocop:disable Metrics/CyclomaticComplexity
    @reward = Reward.new(reward_params)
    if @reward.point_value.present?
      if @reward.point_value > 2_147_483_647
        flash[:alert] = 'Reward could not be created - out of bounds point value.'
        redirect_to(rewards_path) and return
      end
      if @reward.point_value.negative?
        flash[:alert] = 'Reward could not be created - out of bounds point value.'
        redirect_to(rewards_path) and return
      end
    end
    if @reward.dollar_price.present?
      if @reward.dollar_price > 2_147_483_647
        flash[:alert] = 'Reward could not be created - out of bounds dollar price.'
        redirect_to(rewards_path) and return
      end
      if @reward.dollar_price.negative?
        flash[:alert] = 'Reward could not be created - out of bounds dollar price.'
        redirect_to(rewards_path) and return
      end
    end
    if @reward.save
      flash[:notice] = 'Reward was successfully created.'
    else
      puts("Errors: #{@reward.errors.full_messages}") # rubocop:disable Rails/Output
      flash[:alert] = 'Reward could not be created.'
    end
    redirect_to(rewards_path)
  end

  def edit
    @reward = Reward.find(params[:id])
  end

  def update # rubocop:disable Metrics/CyclomaticComplexity
    @reward = Reward.find(params[:id])
    if @reward.point_value.present?
      if @reward.point_value > 2_147_483_647
        flash[:alert] = 'Reward could not be created - out of bounds point value.'
        redirect_to(rewards_path) and return
      end
      if @reward.point_value.negative?
        flash[:alert] = 'Reward could not be created - out of bounds point value.'
        redirect_to(rewards_path) and return
      end
    end
    if @reward.dollar_price.present?
      if @reward.dollar_price > 2_147_483_647
        flash[:alert] = 'Reward could not be created - out of bounds dollar price.'
        redirect_to(rewards_path) and return
      end
      if @reward.dollar_price.negative?
        flash[:alert] = 'Reward could not be created - out of bounds dollar price.'
        redirect_to(rewards_path) and return
      end
    end
    if @reward.update(reward_params)
      flash[:notice] = 'Reward was successfully updated.'
    else
      flash[:alert] = 'Reward could not be updated.'
    end
    redirect_to(reward_path(@reward))
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