# frozen_string_literal: true

class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    admin = Admin.from_google(**from_google_params)

    if admin.blank?
      flash[:alert] = t('devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized.")
      redirect_to(new_admin_session_path) and return
    end

    sign_out_all_scopes
    flash[:notice] = t('devise.omniauth_callbacks.success', kind: 'Google')
    handle_admin(admin)
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_admin_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def handle_admin(admin)
    user = User.find_by(email: admin.email)

    if user&.is_admin?
      set_admin_session(admin, true)
      redirect_to(admin_dashboard_path)
    elsif user
      set_admin_session(admin, false, user.id)
      redirect_to(member_dashboard_path(user))
    else
      create_and_sign_in_user(admin)
    end
  end

  def set_admin_session(admin, is_admin, user_id = nil)
    session[:is_admin] = is_admin
    sign_in(admin, event: :authentication)
    session[:user_id] = user_id if user_id
  end

  def create_and_sign_in_user(admin)
    user = User.create_with_default_stats(admin: admin)
    if user.persisted?
      set_admin_session(admin, false, user.id)
      redirect_to(member_dashboard_path(user))
    else
      redirect_to(new_admin_session_path)
    end
  end

  def from_google_params
    @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email,
      full_name: auth.info.name,
      avatar_url: auth.info.image
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
