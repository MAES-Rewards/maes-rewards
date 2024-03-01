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
end
