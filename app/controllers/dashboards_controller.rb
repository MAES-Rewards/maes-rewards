# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :admin_check, only: [:admin]
  before_action :authorize_user, only: [:member]

  def member
    # @user = User.where(:is_admin => false).where(email: params[:email])
    @user = User.find(params[:id])
  end

  def admin
    @users = User.where(is_admin: false)
  end

  # def home
  #   redirect_to(destroy_admin_session_path)
  # end
end
