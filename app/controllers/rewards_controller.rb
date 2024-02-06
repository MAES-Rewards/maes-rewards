class RewardsController < ApplicationController
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

  def create
    @reward = Reward.new(reward_params)
    if @reward.save
      flash[:notice] = 'Reward was successfully created.'
    else
      puts("Errors: #{@@reward.errors.full_messages}")
      flash[:notice] = 'Reward could not be created.'
    end
    redirect_to(rewards_path)
  end

  def edit
    @reward = Reward.find(params[:id])
  end

  def update
    @reward = Reward.find(params[:id])
    if @reward.update(reward_params)
      flash[:notice] = 'Reward was successfully updated.'
      redirect_to(rewards_path)
    else
      # edit action is NOT being called here
      # assign any instance variables needed
      render('edit')
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
