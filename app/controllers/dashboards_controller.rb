# frozen_string_literal: true

class DashboardsController < ApplicationController
  # Ensure that only officers can access officer dashboard and member is authorized based on session variable
  before_action :admin_check, only: [:admin]
  before_action :authorize_user, only: [:member]

  # Show the member dashboard based on user ID number
  def member
    # @user = User.where(:is_admin => false).where(email: params[:email])
    @user = User.find(params[:user_id])
  end

  # Show the admin dashboard and provides a list of all members
  def admin
    @users = User.where(is_admin: false)
  end

  # Check admin session variable to determine which dashboard to send the user
  def show
    if session[:is_admin]
      redirect_to(admin_dashboard_path)
    else
      redirect_to(member_dashboard_path(session[:user_id]))
    end
  end
end
