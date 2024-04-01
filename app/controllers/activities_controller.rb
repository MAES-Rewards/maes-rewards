# frozen_string_literal: true

class ActivitiesController < ApplicationController
  # Ensure that only officers can access specific functionalities for activities
  before_action :admin_check, only: %I[new edit update delete destroy]

  # Display activities ordered by their name
  def index
    @activities = Activity.order(:name)
  end

  # Show the details of a specific activity based on activity ID number
  def show
    @activity = Activity.find(params[:id])
  end

  # Initializes a new activity
  def new
    @activity = Activity.new
  end

  # Create a new activity using the form parameters. If successfully saved, redirects to the activities page
  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      flash[:notice] = 'Activity was successfully created.'
      redirect_to(activities_path)
    else
      flash[:alert] = 'Activity could not be created. Attribute(s) are invalid.'
      render('new', status: :unprocessable_entity)
    end
  end

  # Finds an existing activity based on its activity ID number
  def edit
    @activity = Activity.find(params[:id])
  end

  # Updates an existing activity using the activity ID number and form parameters. If successfull, redirects back to that activity page
  def update
    @activity = Activity.find(params[:id])
    if @activity.update(activity_params)
      flash[:notice] = 'Activity was successfully updated.'
      redirect_to(activity_path(@activity))
    else
      flash[:alert] = 'Activity could not be updated. Attribute(s) are invalid.'
      render('edit', status: :unprocessable_entity)
    end
  end

  # Finds activity based on activity ID number for deletion
  def delete
    @activity = Activity.find(params[:id])
  end

  # Deletes activity based on activity ID number. If successful, redirect to activities page
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy!
    flash[:notice] = 'Activity was successfully deleted.'
    redirect_to(activities_path)
  end

  private

  # Require specific parameters
  def activity_params
    params.require(:activity).permit(
      :name,
      :description,
      :default_points
    )
  end
end
