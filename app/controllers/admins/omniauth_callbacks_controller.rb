# frozen_string_literal: true

class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # rubocop:disable Metrics/AbcSize
  def google_oauth2
    admin = Admin.from_google(**from_google_params)

    if admin.present?
      sign_out_all_scopes
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: 'Google')

      user = User.find_by(email: admin.email)
      if user&.is_admin?
        session[:is_admin] = true
        sign_in(admin, event: :authentication)
        redirect_to(admin_dashboard_path)
      elsif user
        session[:is_admin] = false
        sign_in(admin, event: :authentication)
        # or user_id = @user.id
        session[:user_id] = user.id
        user_id = User.find_by(email: admin.email)
        redirect_to(member_dashboard_path(user_id))
      else
        session[:is_admin] = false
        @user = User.create!(name: admin.full_name, email: admin.email, points: 0, is_admin: false)
        sign_in(admin, event: :authentication)
        if @user.save!
          # or user_id = @user.id
          user_id = User.find_by(email: admin.email)
          redirect_to(member_dashboard_path(user_id))
        else
          redirect_to(new_admin_session_path)
        end
      end
    else
      flash[:alert] = t('devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized.")
      redirect_to(new_admin_session_path)
    end
  end
  # rubocop:enable Metrics/AbcSize

  protected

  def after_omniauth_failure_path_for(_scope)
    new_admin_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

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
