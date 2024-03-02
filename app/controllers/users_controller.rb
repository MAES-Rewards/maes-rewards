# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_dashboard_path, only: [:activityhistory]
  before_action :set_user, only: [:activityhistory]
  before_action :authorize_user, only: %I[activityhistory show]
  before_action :admin_check, only: %I[points handle_points update delete destroy]

  def index; end

  def show
    @user = User.find(params[:user_id])
  end

  # find all non-admin users to assign points in bulk
  def points
    @users = User.where(is_admin: false).order(:name)
  end

  # execute point assignment by using selected user ids, point amount, and associated activity
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  def handle_points
    @users = User.where(is_admin: false).order(:name)
    @selected_activity = nil
    @selected_activity = Activity.find_by(id: params[:recur_activity_id]) if params[:recur_activity_id].present?

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

    # iterate through selected users and assign points
    selected_user_ids ||= []
    saved = true
    selected_user_ids.each do |user_id|
      user = User.find(user_id)
      if (user.points + Integer(new_points, 10)).negative? || user.points + Integer(new_points, 10) > 2_147_483_647
        flash[:alert] = 'Enter a valid point value.'
        return redirect_to(member_points_url)
      else
        user.points += Integer(new_points, 10)
        saved = false unless user.save!

        ActiveRecord::Base.transaction do
          transaction = user.earn_transactions.build(points: Integer(new_points, 10), activity_id: recur_activity_id)
          unless transaction.save && user.save
            saved = false
            raise(ActiveRecord::Rollback, 'Failed to save user or transaction')
          end
        end
      end
    end

    # check if saved, create corresponding flash notice
    if saved
      flash[:notice] = 'User(s) were successfully updated.'
      redirect_to(admin_dashboard_path)
    else
      flash[:alert] = 'User(s) were not updated successfully.'
      redirect_to(member_points_url)
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

  def activityhistory
    @earn_transactions = @user.earn_transactions.includes(:activity).order(created_at: :desc)
    @earn_transactions = @earn_transactions.where(activity_id: params[:activity_id]) if params[:activity_id].present?
    @earn_transactions = @earn_transactions.where('created_at >= ?', Date.parse(params[:start_date])) if params[:start_date].present?
    @earn_transactions = @earn_transactions.where('created_at <= ?', Date.parse(params[:end_date])) if params[:end_date].present?
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
    unless @user
      flash[:alert] = 'User not found.'
      redirect_to(destroy_admin_session_path)
    end
  end

  def set_dashboard_path
    @dashboard_path = session[:is_admin] ? admin_dashboard_path : member_dashboard_path
  end

  def new; end

  def edit
    @user = User.find(params[:user_id])
  end

  def update
    @user = User.find(params[:user_id])
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
  end

  def delete
    @user = User.find(params[:user_id])
  end

  def destroy
    flash[:notice] = 'User successfully deleted.'
    User.find(params[:user_id]).destroy!
    redirect_to(admin_dashboard_path)
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
