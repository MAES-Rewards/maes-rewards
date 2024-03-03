# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  helper_method :render_menu

  def render_menu
    if session[:is_admin]
      render(partial: 'layouts/adminmenu')
    elsif session[:is_admin] == false
      render(partial: 'layouts/membermenu')
    end
  end

  private

  def admin_check
    unless session[:is_admin]
      flash[:alert] = 'Access denied. Please log in as an admin.'
      redirect_to(destroy_admin_session_path)
    end
  end

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
