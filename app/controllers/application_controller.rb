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
end
