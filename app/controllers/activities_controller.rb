class ActivitiesController < ApplicationController
  def index
    @activities = Activity.order(:name)
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
    if session[:is_admin]
      @activity = Activity.new
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to activities_path
    end
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      flash[:notice] = 'Activity was successfully created.'
      redirect_to activities_path
    else
      flash[:alert] = 'Activity could not be created. Attribute(s) are invalid.'
      render('new', status: 422)
    end
  end

  def edit
    if session[:is_admin]
      @activity = Activity.find(params[:id])
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to activities_path
    end
  end

  def update
    if session[:is_admin]
      @activity = Activity.find(params[:id])
      if @activity.update(activity_params)
        flash[:notice] = 'Activity was successfully updated.'
        redirect_to activity_path(@activity)
      else
        flash[:alert] = 'Activity could not be updated. Attribute(s) are invalid.'
        render('edit', status: 422)
      end
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to activities_path
    end
  end

  def delete
    if session[:is_admin]
      @activity = Activity.find(params[:id])
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to activities_path
    end
  end

  def destroy
    if session[:is_admin]
      @activity = Activity.find(params[:id])
      @activity.destroy
      flash[:notice] = 'Activity was successfully deleted.'
      redirect_to activities_path
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to activities_path
    end
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
