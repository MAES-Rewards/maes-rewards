# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Google OAuth login', type: :feature) do
  context 'MEMBER login' do
    let!(:user) { User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: false) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: {
          email: 'user@tamu.edu',
          name: 'John Doe'
        }
      }
                                                                        )
      page.set_rack_session(user_id: user.id, is_admin: false)
    end

    it 'user logs in with Google to member page' do
      visit new_admin_session_path
      click_on 'Sign in via Google'

      # Assuming there is some delay or asynchronous operation happening
      # If content doesn't appear immediately, wait for it
      expect(page).to(have_content('Welcome, John Doe!'))
    end
  end

  context 'ADMIN login' do
    let!(:user) { User.create!(email: 'ahartman03@tamu.edu', name: 'Anna Hartman', points: 0, is_admin: true) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: 'ahartman03@tamu.edu',
          name: 'Anna Hartman'
        }
      }
                                                                        )
      page.set_rack_session(user_id: user.id, is_admin: true)
    end

    it 'user logs in with Google into admin page' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      # Assuming there is some delay or asynchronous operation happening
      # If content doesn't appear immediately, wait for it
      expect(page).to(have_content('All Members'))
      expect(page).to(have_content('Activities'))
      # Activities is only displayed for Admin.
    end
  end
end
