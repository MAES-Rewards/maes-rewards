# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Bulk Points', type: :feature) do
  context 'Failed Attempts' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'John Doe' }
      })

      User.create!(email: 'user1@tamu.edu', name: 'John Doe', points: 100, is_admin: false)
      User.create!(email: 'user2@tamu.edu', name: 'Jane Doe', points: 10, is_admin: false)

    end

    it 'Attempts to subtract too many points' do
      user1 = User.where(:email => "user1@tamu.edu").first
      user2 = User.where(:email => "user2@tamu.edu").first
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      check("selected_users[]", match: :first, option: user1.id)
      check("selected_users[]", match: :first, option: user2.id)

      # Fill in points
      fill_in 'new_points', with: -20

      # Select associated recurring activity
      select 'Custom One-Time Activity', from: 'recur_activity_id'

      # Fill in associated one-time activity (optional)
      fill_in 'onetime_activity_string', with: 'Example Activity'

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('Enter a valid point value.')

    end

    it 'Attempts to add too many points' do
      user1 = User.where(:email => "user1@tamu.edu").first
      user2 = User.where(:email => "user2@tamu.edu").first
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      check("selected_users[]", match: :first, option: user1.id)
      check("selected_users[]", match: :first, option: user2.id)

      # Fill in points
      fill_in 'new_points', with: 100000000000

      # Select associated recurring activity
      select 'Custom One-Time Activity', from: 'recur_activity_id'

      # Fill in associated one-time activity (optional)
      fill_in 'onetime_activity_string', with: 'Example Activity'

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('Enter a valid point value.')

    end
    it 'Attempts to leave activity blank' do
      user1 = User.where(:email => "user1@tamu.edu").first
      user2 = User.where(:email => "user2@tamu.edu").first
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      check("selected_users[]", match: :first, option: user1.id)
      check("selected_users[]", match: :first, option: user2.id)

      # Fill in points
      fill_in 'new_points', with: 10

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('Please select or enter an activity.')

    end
  end
  context 'Successful Attempts' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'John Doe' }
      })

      User.create!(email: 'user1@tamu.edu', name: 'John Doe', points: 100, is_admin: false)
      User.create!(email: 'user2@tamu.edu', name: 'Jane Doe', points: 10, is_admin: false)
      Activity.create!(name: "Great Activity", description: "Yay", default_points: 2)
    end
    it 'Adds 10 points to each user.' do
      user1 = User.where(:email => "user1@tamu.edu").first
      user2 = User.where(:email => "user2@tamu.edu").first
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      check("selected_users[]", match: :first, option: user1.id)
      check("selected_users[]", match: :first, option: user2.id)

      # Fill in points
      fill_in 'new_points', with: 10

      # Select associated recurring activity
      select 'Custom One-Time Activity', from: 'recur_activity_id'

      # Fill in associated one-time activity (optional)
      fill_in 'onetime_activity_string', with: 'Example Activity'

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('User(s) were successfully updated.')

      click_on 'Home'

      expect(page).to(have_content('20'))
      expect(page).to(have_content('110'))

    end
    it 'Subtracts 10 points from each user.' do
      user1 = User.where(:email => "user1@tamu.edu").first
      user2 = User.where(:email => "user2@tamu.edu").first
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      check("selected_users[]", match: :first, option: user1.id)
      check("selected_users[]", match: :first, option: user2.id)

      # Fill in points
      fill_in 'new_points', with: -10

      # Select associated recurring activity
      select 'Custom One-Time Activity', from: 'recur_activity_id'

      # Fill in associated one-time activity (optional)
      fill_in 'onetime_activity_string', with: 'Example Activity'

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('User(s) were successfully updated.')

      click_on 'Home'

      expect(page).to(have_content('0'))
      expect(page).to(have_content('100'))

    end
    it 'Adds 10 points to each user with recurring activity.' do
      user1 = User.where(:email => "user1@tamu.edu").first
      user2 = User.where(:email => "user2@tamu.edu").first
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      check("selected_users[]", match: :first, option: user1.id)
      check("selected_users[]", match: :first, option: user2.id)

      # Fill in points
      fill_in 'new_points', with: 10

      # Select associated recurring activity
      select 'Great Activity', from: 'recur_activity_id'

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('User(s) were successfully updated.')

      click_on 'Home'

      expect(page).to(have_content('0'))
      expect(page).to(have_content('100'))

    end
    it 'Adds 50 points to all users with select all button.' do
      user1 = User.where(:email => "user1@tamu.edu").first
      user2 = User.where(:email => "user2@tamu.edu").first
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Assign Points'

      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      click_on 'Select All Users'

      # Fill in points
      fill_in 'new_points', with: 50

      # Select associated recurring activity
      select 'Great Activity', from: 'recur_activity_id'

      # Submit the form
      click_button 'Submit'

      expect(page).to have_content('User(s) were successfully updated.')

      click_on 'Home'

    end
  end
end
