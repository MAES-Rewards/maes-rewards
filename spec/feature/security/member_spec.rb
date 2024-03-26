# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Testing Security', type: :feature) do
  let!(:user) { User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: false) }

  context 'as member' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'John Doe' }
      }
                                                                        )
      page.set_rack_session(user_id: user.id, is_admin: false)
      Reward.create!(name: 'Sample Reward', point_value: 50, inventory: 10, dollar_price: 100)
      Activity.create!(name: 'Sample Activity', description: 'This is an activity', default_points: 100)
    end

    # Member Login Sunny Day Test
    it 'logins in to the website using Google OAuth' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
    end

    # Member Home Sunny Day Test
    it 'presses home' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'Home'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
    end

    # Member Rewards Sunny Day Test
    it 'presses view rewards' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'View Rewards'
      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Sample Reward'))
    end

    it 'logins in to the website, navigates to rewards, and presses see details' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'View Rewards'
      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Sample Reward'))

      within('tr', text: 'Sample Reward') do
        click_on 'See details'
      end
      expect(page).to(have_content('Sample Reward details'))
      expect(page).to(have_content('Back to all Rewards'))
      expect(page).to(have_content('50'))
    end

    it 'logins in to the website, navigates to rewards, and presses purchase' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'View Rewards'
      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Sample Reward'))

      within('tr', text: 'Sample Reward') do
        click_on 'Purchase'
      end
      expect(page).to(have_content('Purchase reward: Sample Reward'))
      expect(page).to(have_content('Are you sure you want to purchase this reward?'))
      expect(page).to(have_content('Sample Reward for 50 point(s).'))
    end

    # Member My Account Sunny Day Test
    it 'presses my account' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'My Account'
      expect(page).to(have_content('My Account'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('user@tamu.edu'))
    end

    # Member Activity History Sunny Day Test
    it 'presses view my history' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'View My History'
      expect(page).to(have_content('All of the activites you have participated in are shown below.'))
      expect(page).to(have_content('Activity History'))
      expect(page).to(have_content('Sample Activity'))
    end

    # Member Sign Out Sunny Day Test
    it 'log out of website' do
      visit new_admin_session_path

      click_on 'Sign Out'
      expect(page).to(have_content('Log in to MAES App'))
    end
  end
end
