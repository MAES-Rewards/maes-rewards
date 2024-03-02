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
    user_id = Integer(params[:id], 10)
    if session[:is_admin]
      redirect_to(admin_dashboard_path) and return
    elsif user_id.nil? || session[:user_id] != user_id
      flash[:alert] = 'You are not authorized to view this page.'
      redirect_to(member_dashboard_path(session[:user_id])) and return
    end
  end
end
