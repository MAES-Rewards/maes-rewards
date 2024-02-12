class DashboardsController < ApplicationController
  before_action :authenticate_admin!

  def member
    # @user = User.where(:is_admin => false).where(email: params[:email])
    @user = User.find(params[:id])
  end

  def admin
    # Additional logic here if needed
    if session[:is_admin]
      @users = User.where(is_admin: false)
    else
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to(destroy_admin_session_path)
    end
  end
end
