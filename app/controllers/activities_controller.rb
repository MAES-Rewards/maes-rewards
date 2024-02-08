class ActivitiesController < ApplicationController
  def index
    @activities = Activity.order(:name)
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      flash[:notice] = 'Activity was successfully created.'
      redirect_to activities_path
    else
      flash[:alert] = 'Activity could not be created. Attribute(s) are invalid.'
      render('new')
    end
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.save
      flash[:notice] = 'Activity was successfully updated.'
      puts("\x1B[92mHELLO GOOD\x1B[m") # TODO REMOVE
      puts("\x1B[92m  Name: #{@activity.name}\x1B[m")
      redirect_to activity_path(@activity)
    else
      flash[:alert] = 'Activity could not be updated. Attribute(s) are invalid.'
      puts("\x1B[91mHELLO BAD\x1B[m") # TODO REMOVE
      render('edit')
    end
  end

  def delete
    @activity = Activity.find(params[:id])
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    flash[:notice] = 'Activity was successfully deleted.'
    redirect_to activities_path
  end

  private

  def activity_params
    params.require(:activity).permit(
      :name,
      :description,
      :default_points
    )
  end
end
