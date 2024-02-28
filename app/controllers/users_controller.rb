# frozen_string_literal: true

class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find(params[:id])
    @txn_hist = build_txn_history(@user.id)
  end

  # find all non-admin users to assign points in bulk
  def points
    if session[:is_admin]
      @users = User.where(is_admin: false).order(:name)
    else
      redirect_to(destroy_admin_session_path)
    end
  end

  # execute point assignment by using selected user ids, point amount, and associated activity
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  def handle_points
    if session[:is_admin]
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
      # redirect to landing page
    else
      redirect_to(destroy_admin_session_path)
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

  def new; end

  def edit
    @user = User.find(params[:id])
    @txn_hist = build_txn_history(@user.id)
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

  private

  def build_txn_history(user_id)
    earn_txns = EarnTransaction.where(user_id: user_id)
    spend_txns = SpendTransaction.where(user_id: user_id)
    txn_hist = []

    earn_txns.each do |earn_txn|
      activity = Activity.find(earn_txn.activity_id)
      txn_hist << {
        user_id: earn_txn.user_id,
        item: activity.name,
        type_id: 'earn',
        type: 'Earned',
        points: "+#{earn_txn.points}"
      }
    end

    spend_txns.each do |spend_txn|
      reward = Reward.find(spend_txn.reward_id)
      txn_hist << {
        user_id: spend_txn.user_id,
        item: reward.name,
        # TODO: Add points here when added to EarnTransaction
        type_id: 'spend',
        type: 'Spent',
        points: "\u2212#{reward.point_value}"
      }
    end

    txn_hist.sort_by! { |txn| txn[:timestamp] }

    txn_hist
  end
end
