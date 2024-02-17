# frozen_string_literal: true

class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find(params[:id])
  end

  def points
    @users = User.where(is_admin: false).order(:name)

  end

  def handle_points
    @users = User.where(is_admin: false).order(:name)
    selected_user_ids = params[:selected_users]
    new_points = params[:new_points]
    activity_id = params[:activity_id]

    selected_user_ids ||= []
    saved = true
    selected_user_ids.each do |user_id|
      user = User.find(user_id)
      user.points += new_points.to_i
      unless user.save!
        saved = false
      end
    end
    if saved
      flash[:notice] = 'Users were successfully updated.'
    else
      flash[:notice] = 'Users were not updated successfully.'
    end
    redirect_to(admin_dashboard_path)
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
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
    end
    redirect_to(destroy_admin_session_path)
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
