class DashboardsController < ApplicationController
  before_action :authenticate_admin!

  def member
    # Additional logic here if needed
  end

  def admin
    # Additional logic here if needed
  end
end