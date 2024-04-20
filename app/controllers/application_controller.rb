# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Ensure that the user has been authenticated for proceeding
  before_action :authenticate_admin!
  helper_method :render_menu

  # Render navigation menu based on if user is officer or member
  def render_menu
    if session[:is_admin]
      render(partial: 'layouts/adminmenu')
    elsif session[:is_admin] == false
      render(partial: 'layouts/membermenu')
    end
  end

  private

  # Checks if the admin session variable is true. If not, redirect to login page
  def admin_check
    unless session[:is_admin]
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to(destroy_admin_session_path)
    end
  end

  # Checks if user ID in parameter matches current user ID. If not, redirect them back to their dashboard
  def authorize_user
    # return if Rails.env.test?

    user_id = Integer(params[:user_id], 10)
    if session[:is_admin]
      redirect_to(admin_dashboard_path)
    elsif session[:user_id] != user_id
      flash[:alert] = 'You are not authorized to view this page.'
      redirect_to(member_dashboard_path(session[:user_id]))
    end
  end
end
