# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Testing Officer Usability with Clicks', type: :feature) do
  let!(:user) { User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: true) }

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

    # Officer Rewards Click Test
    it 'logins to the website and views the Officer rewards page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))
      counter = 0

      click_on 'Rewards'
      counter += 1
      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Search:'))

      expect(counter).to(be <= 2)
    end

    # Officer Activities Click Test
    it 'logins to the website and views the Officer activities page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))
      counter = 0

      click_on 'Activities'
      counter += 1
      expect(page).to(have_content('Activities'))
      expect(page).to(have_content('Add New Activity'))
      expect(page).to(have_content('Sample Activity'))

      expect(counter).to(be <= 2)
    end

    # Officer Assign Points Click Test
    it 'logins to the website and views the Officer Assign Points page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))
      counter = 0

      click_on 'Assign Points'
      counter += 1
      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('Assign points to members by selecting them from the list below, choosing the point amount (positive or negative), and choosing a one-time or recurring activity associated with the points.'))
      expect(page).to(have_content('Member List:'))

      expect(counter).to(be <= 2)
    end

    # Officer History Click Test
    it 'logins to the website and views the Officer History page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))
      counter = 0

      click_on 'History'
      counter += 1
      expect(page).to(have_content('History'))
      expect(page).to(have_content('Filter by type:'))

      expect(counter).to(be <= 2)
    end

    # Officer Notifications Click Test
    it 'logins to the website and views the Officer Notifications page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))
      counter = 0

      click_on 'Notifications'
      counter += 1
      expect(page).to(have_content('Reward Notifications'))
      expect(page).to(have_content('All reward purchases made in the last 24 hours are listed here.'))

      expect(counter).to(be <= 2)
    end

    # Officer Help Click Test
    it 'logins to the website and views the Officer Help page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))
      counter = 0

      click_on 'Help'
      counter += 1
      expect(page).to(have_content('Documentation'))
      expect(page).to(have_content('When an event occurs, points can be awarded in bulk through the Assign Points page. Users can be easily checked off, and officers can search the list as well as only display selected users. When the form is submitted, all users will be given the specified amount of points associated with the specified activity. There is also a Custom One-Time Activity option, where a custom point adjustment can be made for the transaction records without having to create a new activity.'))

      expect(counter).to(be <= 2)
    end
  end
end
