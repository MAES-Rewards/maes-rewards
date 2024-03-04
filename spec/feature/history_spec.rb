# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Testing History', type: :feature) do
  let!(:user) { User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: true) }
  let!(:user1) { User.create!(email: 'user1@tamu.edu', name: 'Jim Doe', points: 100, is_admin: false) }

  context 'as officer' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'John Doe' }
      }
                                                                        )
      page.set_rack_session(user_id: user.id, is_admin: true)
      Reward.create!(name: 'Sample Reward', point_value: 50, inventory: 10, dollar_price: 100)
      Activity.create!(name: 'Sample Activity', description: 'This is an activity', default_points: 100)
    end

    # officer history sunny day test
    it 'logins in to the website and presses history' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      expect(page).to(have_content('Admin Home'))

      click_on 'History'

      expect(page).to(have_content('History'))
      expect(page).to(have_content('Type'))
      expect(page).to(have_content('User Name'))
      expect(page).to(have_content('Reward/Activity Name'))
      expect(page).to(have_content('Points'))
      expect(page).to(have_content('Created At'))
      expect(page).to(have_content('Updated At'))
    end

    it 'assings points to a user and checks history' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))

      check('selected_users[]', match: :first, option: user1.id)

      fill_in 'new_points', with: 10

      select 'Sample Activity', from: 'recur_activity_id'

      click_button 'Submit'

      click_on 'History'

      expect(page).to(have_content('Activity'))
      expect(page).to(have_content('Jim Doe'))
      expect(page).to(have_content('Sample Activity'))
      expect(page).to(have_content('+10'))
    end
  end
end
