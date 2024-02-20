# frozen_string_literal: true

class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find(params[:id])
  end

  # find all non-admin users to assign points in bulk
  def points
    if (session[:is_admin])
      @users = User.where(is_admin: false).order(:name)
    else
      redirect_to destroy_admin_session_path
    end

  end

  # execute point assignment by using selected user ids, point amount, and associated activity
  def handle_points
    if session[:is_admin]
      @users = User.where(is_admin: false).order(:name)

      @selected_activity = nil

      if params[:recur_activity_id].present?
        @selected_activity = Activity.find_by(id: params[:recur_activity_id])
      end

      # selected fields
      selected_user_ids = params[:selected_users]
      new_points = params[:new_points]
      recur_activity_id = params[:recur_activity_id]
      onetime_activity_string = params[:onetime_activity_string]

      # check if for activity associated one-time & recurring, both are blank or both are selected
      if recur_activity_id.blank? && onetime_activity_string.blank?
        flash[:alert] = 'Please select or enter an activity.'
        redirect_to(member_points_url) and return
      end

      if !recur_activity_id.blank? && !onetime_activity_string.blank?
        flash[:alert] = 'Cannot enter values for both recurring and one time activity.'
        redirect_to(member_points_url) and return
      end



      # iterate through selected users and assign points
      selected_user_ids ||= []
      saved = true
      selected_user_ids.each do |user_id|
        user = User.find(user_id)
        if (user.points + new_points.to_i < 0 || user.points + new_points.to_i > 2147483647)
          flash[:alert] = 'Enter a valid point value.'
          redirect_to(member_points_url) and return
        else
          user.points += new_points.to_i
          unless user.save!
            saved = false
          end
        end
      end

      # check if saved, create corresponding flash notice
      if saved
        flash[:notice] = 'User(s) were successfully updated.'
        redirect_to(admin_dashboard_path)
      else
        flash[:alert] = 'User(s) were not updated successfully.'
        redirect_to member_points_url
      end
      # redirect to landing page
    else
      redirect_to destroy_admin_session_path
    end
  end

  def new; end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if session[:is_admin]
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:notice] = 'User was successfully updated.'
        if session[:is_admin]
          redirect_to(admin_dashboard_path)
        else
          redirect_to(user_path(@user))
        end
      else
        flash[:alert] = 'User could not be updated. Attribute(s) are invalid.'
        render('edit', status: :unprocessable_entity)
      end
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to(destroy_admin_session_path)
    end
  end

  def delete
    if session[:is_admin]
      @user = User.find(params[:id])
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to(destroy_admin_session_path)
    end
  end

  def destroy
    if session[:is_admin]
      User.find(params[:id]).destroy!
      redirect_to(admin_dashboard_path)
      flash[:notice] = 'User successfully deleted.'
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to(destroy_admin_session_path)
    end

  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :points,
      :is_admin
    )
  end
end
