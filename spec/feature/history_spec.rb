# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Transaction History', type: :feature) do
  let!(:user1) { User.create!(email: 'user1@tamu.edu', name: 'John Doe', points: 5, is_admin: false) }
  let!(:user2) { User.create!(email: 'user2@tamu.edu', name: 'Jane Doe', points: 0, is_admin: true) }
  let!(:activity1) { Activity.create!(name: 'Test Activity', description: 'Description of Test Activity', default_points: 25) }
  let!(:reward1) { Reward.create!(name: 'Test Activity', point_value: 20, dollar_price: 19.99, inventory: 1) }

  context 'Successful & Unsuccessful Attempts' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user2@tamu.edu', name: 'John Doe' }
      }
                                                                        )
      page.set_rack_session(user_id: user2.id, is_admin: true)
    end

    it 'User completes activity & shown in admin txn history' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      visit edit_user_path(user1)

      expect(page).not_to(have_content('+25'))

      visit admin_dashboard_path

      click_on 'Assign Points'

      check('selected_users[]', match: :first, option: user1.id)

      # Fill in points
      fill_in 'new_points', with: 25

      # Select associated recurring activity
      select activity1.name, from: 'recur_activity_id'

      # Fill in associated one-time activity (optional)
      fill_in 'onetime_activity_string', with: ''

      # Submit the form
      click_button 'Submit'

      expect(page).to(have_content('User(s) were successfully updated.'))

      visit edit_user_path(user1)

      expect(page).to(have_content('+25'))
    end

    it 'User purchases reward & shown in admin txn history' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      # Give user1 enough points
      user1.update!(points: 25)

      visit edit_user_path(user1)

      expect(page).not_to(have_content("\u221220"))

      page.set_rack_session(user_id: user1.id, is_admin: false)

      visit memshow_path_url(id: reward1.id, user_id: user1.id)

      click_on 'Purchase'
      click_on 'Confirm'

      expect(page).to(have_content('Reward was successfully purchased.'))

      page.set_rack_session(user_id: user2.id, is_admin: true)

      visit edit_user_path(user1)

      expect(page).to(have_content("\u221220"))
    end

    it 'User fails to purchase reward & not shown in admin txn history' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      # Don't give user1 enough points

      visit edit_user_path(user1)

      expect(page).not_to(have_content("\u221220"))

      page.set_rack_session(user_id: user1.id, is_admin: false)

      visit memshow_path_url(id: reward1.id, user_id: user1.id)

      click_on 'Purchase'
      click_on 'Confirm'

      expect(page).to(have_content('Reward is out of stock or user does not have sufficient points.'))

      page.set_rack_session(user_id: user2.id, is_admin: true)

      visit edit_user_path(user1)

      expect(page).not_to(have_content("\u221220"))
    end
  end
end
# frozen_string_literal: true

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
