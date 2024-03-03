# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_dashboard_path, only: [:activityhistory]
  before_action :set_user, only: [:activityhistory]
  before_action :authorize_user, only: %I[activityhistory show]
  before_action :admin_check, only: %I[points handle_points update delete destroy new edit]

  # def index; end

  def show
    @user = User.find(params[:user_id])
    @txn_hist = build_txn_history(@user.id)
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
            user.errors.full_messages
            transaction.errors.full_messages
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
    @spend_transactions = @user.spend_transactions.includes(:reward).order(created_at: :desc)
    @spend_transactions = @spend_transactions.where(reward_id: params[:reward_id]) if params[:reward_id].present?
    @spend_transactions = @spend_transactions.where(created_at_since_condition)
    @spend_transactions = @spend_transactions.where(created_at_until_condition)
  end

  def created_at_since_condition
    ['created_at >= ?', Date.parse(params[:reward_start_date])] if params[:reward_start_date].present?
  end

  def created_at_until_condition
    ['created_at <= ?', Date.parse(params[:reward_end_date])] if params[:reward_end_date].present?
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

  # def new; end

  def edit
    @user = User.find(params[:user_id])
    @txn_hist = build_txn_history(@user.id)
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
    params.require(:user).permit(:name, :email, :points, :is_admin)
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
        points: "+#{earn_txn.points}",
        timestamp: activity[:created_at]
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
        points: "\u2212#{spend_txn.points}",
        timestamp: reward[:created_at]
      }
    end

    txn_hist.sort_by! { |txn| txn[:timestamp] }.reverse!

    txn_hist
  end
end
