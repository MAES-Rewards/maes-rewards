# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :admin_check, only: [:admin]
  before_action :authorize_user, only: [:member]

  def member
    # @user = User.where(:is_admin => false).where(email: params[:email])
    @user = User.find(params[:user_id])
  end

  def admin
    @users = User.where(is_admin: false)
  end

  def show
    if session[:is_admin]
      redirect_to admin_dashboard_path
    else
      redirect_to member_dashboard_path(session[:user_id])
    end
  end
end
