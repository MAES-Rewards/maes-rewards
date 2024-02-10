class DashboardsController < ApplicationController
  before_action :authenticate_admin!

  def member
    @user = User.where(:is_admin => false).first
    # admin = Admin.from_google(**from_google_params)
  
    # if admin.present?
    #   sign_out_all_scopes
    #   flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      
    #   @user = User.find_by(email: admin.email)
    # else
    #   flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
    #   redirect_to new_admin_session_path
    # end
  end

  def admin
    # Additional logic here if needed
  end
end