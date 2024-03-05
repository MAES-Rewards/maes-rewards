# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Transaction History', type: :feature) do
  let!(:user1) { User.create!(email: 'user1@tamu.edu', name: 'John Doe', points: 5, is_admin: false) }
  let!(:user2) { User.create!(email: 'user2@tamu.edu', name: 'Jane Doe', points: 0, is_admin: true) }
  let!(:activity1) { Activity.create!(name: 'Test Activity', description: 'Description of Test Activity', default_points: 25) }
  let!(:reward1) { Reward.create!(name: 'Test Activity', point_value: 20, dollar_price: 19.99, inventory: 1) }

  context 'Successful Attempts' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'John Doe' }
      }
                                                                        )
    end

    it 'User completes activity & shown in admin txn history' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      visit user_edit_path(user1)

      expect(page).not_to have_content("+30")

      visit admin_dashboard_path

      click_on 'Assign Points'

      check('selected_users[]', match: :first, option: user1.id)

      # Fill in points
      fill_in 'new_points', with: 25

      # Select associated recurring activity
      select 'Test Activity', from: 'recur_activity_id'

      # Fill in associated one-time activity (optional)
      fill_in 'onetime_activity_string', with: ''

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('User(s) were successfully updated.')

      visit user_path(user1)

      expect(page).to have_content('+30')
    end
  end
end
