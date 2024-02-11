class DashboardsController < ApplicationController
  before_action :authenticate_admin!

  def member
    # @user = User.where(:is_admin => false).where(email: params[:email])
    @user = User.find(params[:id])
  end

  def admin
    # Additional logic here if needed
    @users = User.all
  end
end