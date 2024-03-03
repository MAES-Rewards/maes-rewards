# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Activity', type: :feature) do
  let!(:user) { User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: false) }

  context 'MEMBER login' do
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

    it 'member user logs in with Google to new activity page' do
      # visit new_admin_session_path
      # click_on 'Sign in via Google'
      visit new_activity_path
      expect(page).to(have_content('Sign in via Google'))
    end
  end

  context 'ADMIN login' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: 'jbeeber@tamu.edu',
          name: 'James Beeber'
        }
      }
                                                                        )
      page.set_rack_session(is_admin: true)
    end

    it 'admin user logs in with Google and creates, edits, and deletes activity' do
      # Your existing code for admin login and activity manipulation
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path

      visit new_activity_path

      fill_in 'activity[name]', with: 'Test Activity'
      fill_in 'activity[description]', with: 'Test Description'
      fill_in 'activity[default_points]', with: -1
      click_on 'Create Activity'
      expect(page).to(have_content('Activity could not be created'))
      fill_in 'activity[default_points]', with: 100
      click_on 'Create Activity'
      expect(page).to(have_content('Test Activity'))

      visit activities_path
      expect(page).to(have_content('Test Activity'))

      visit activity_path(Activity.last)
      expect(page).to(have_content('Test Activity'))
      expect(page).to(have_content('Edit'))
      expect(page).to(have_content('Delete'))

      click_on 'Edit'
      fill_in 'activity[description]', with: ''
      click_on 'Save Changes'
      expect(page).to(have_content('Activity could not be updated'))
      fill_in 'activity[description]', with: 'A New Test Description'
      click_on 'Save Changes'
      expect(page).to(have_content('A New Test Description'))

      click_on 'Delete'
      expect(page).to(have_content('Are you sure'))
      click_on 'Delete Activity'
      expect(page).to(have_content('Activity was successfully deleted'))
      expect(page).not_to(have_content('Test Activity'))
    end
  end
end
