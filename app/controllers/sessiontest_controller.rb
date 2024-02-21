# frozen_string_literal: true

class SessiontestController < ApplicationController
  def set_admin_session
    session[:is_admin] = true
    redirect_to(new_admin_session_path)
    # Redirect to the home page or wherever appropriate
  end
end
