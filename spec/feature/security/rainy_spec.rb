# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Testing Security', type: :feature) do
  let!(:user) { User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: false) }
  let!(:other_user) { User.create!(email: 'other_user@tamu.edu', name: 'James James', points: 100, is_admin: false) }
  let!(:reward) { Reward.create!(name: 'Sample Reward', point_value: 50, inventory: 10, dollar_price: 100) }
  let!(:activity) { Activity.create!(name: 'Sample Activity', description: 'This is an activity', default_points: 100) }

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
      page.set_rack_session(user_id: other_user.id, is_admin: false)
    end

    # Member Login Sunny Day Test
    it 'logins in to the website using Google OAuth' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
    end

    # Member Home Sunny Day Test
    it 'logins in to the website and presses home' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'Home'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
    end

    # Member Home Rainy Day Test
    it 'logins in to the website and attempts to go to dashboard of other member' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      visit member_dashboard_path(other_user.id)
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      expect(page).to(have_content('You are not authorized to view this page'))
    end

    # Member Rewards Rainy Day Tests
    it 'logins in to the website and attempts to view rewards of other member' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'View Rewards'
      expect(page).to(have_content('Rewards (member view)'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Sample Reward'))

      visit memrewards_path_path(other_user.id)
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      expect(page).to(have_content('You are not authorized to view this page'))
    end

    it 'logins in to the website, navigate to rewards, and attempts to see detail of reward of other member' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'View Rewards'
      expect(page).to(have_content('Rewards (member view)'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Sample Reward'))

      within('tr', text: 'Sample Reward') do
        click_on 'See details'
      end
      expect(page).to(have_content('Sample Reward details'))
      expect(page).to(have_content('Back to all Rewards'))
      expect(page).to(have_content('50'))

      visit memshow_path_path(id: reward.id, user_id: other_user.id)
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      expect(page).to(have_content('You are not authorized to view this page'))
    end

    it 'logins in to the website and attemps to purchase reward as other member' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      click_on 'View Rewards'
      expect(page).to(have_content('Rewards (member view)'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Sample Reward'))

      within('tr', text: 'Sample Reward') do
        click_on 'Purchase'
      end
      expect(page).to(have_content('Purchase reward: Sample Reward'))
      expect(page).to(have_content('Are you sure you want to purchase this reward?'))
      expect(page).to(have_content('Sample Reward for 50 point(s).'))

      visit purchase_path_path(id: reward.id, user_id: other_user.id)
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      expect(page).to(have_content('You are not authorized to view this page'))
    end

    # Member My Account Rainy Day Tests
    it 'logins in to the website and attempts to view account of other user' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      visit user_path(other_user.id)
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      expect(page).to(have_content('You are not authorized to view this page'))
    end

    # Member View My History Rainy Day Tests
    it 'logins in to the website and attempts to view activity history of other member' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))

      user_history_activity_path(user_id: other_user.id)
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
    end

    # attempt to access admin dashboard
    it 'member access admin dashboard as member' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))
    end

    # access admin rewards page
    it 'member access admin rewards' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit rewards_path
      expect(page).to(have_content('Log in to MAES App'))

      visit rewards_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit new_reward_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_reward_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_reward_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin activities
    it 'access admin activites' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit activities_path
      expect(page).to(have_content('Log in to MAES App'))

      visit activity_path(id: activity.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit new_activity_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_activity_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_activity_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin assign points
    it 'access admin assign points' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit member_points_path
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin users
    it 'access admin users' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit new_user_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_user_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_user_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))
    end
  end

  context 'as unauthorized user' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@gmail.com', name: 'John Doe' }
      }
                                                                        )
      page.set_rack_session(user_id: user.id, is_admin: false)
      page.set_rack_session(user_id: other_user.id, is_admin: false)
    end

    # Unauthorized user attempts to login
    it 'login as non @tamu.edu account' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin dashboard
    it 'access admin dashboard' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin rewards
    it 'access admin rewards' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit rewards_path
      expect(page).to(have_content('Log in to MAES App'))

      visit rewards_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit new_reward_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_reward_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_reward_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin activities
    it 'access admin activites' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit activities_path
      expect(page).to(have_content('Log in to MAES App'))

      visit activity_path(id: activity.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit new_activity_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_activity_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_activity_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin assign points
    it 'access admin assign points' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit member_points_path
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin users
    it 'access admin users' do
      visit new_admin_session_path

      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit new_user_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_user_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_user_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))
    end
  end

  context 'as user trying to bypass oauth' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@gmail.com', name: 'John Doe' }
      }
                                                                        )
      page.set_rack_session(user_id: user.id, is_admin: false)
      page.set_rack_session(user_id: other_user.id, is_admin: false)
    end

    # attempt to access admin dashboard without logging in
    it 'not logging in and try to get to admin dashboard page' do
      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))
    end

    # access admin rewards page without loggin in
    it 'not loggin in, trying to access admin rewards page' do
      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit rewards_path
      expect(page).to(have_content('Log in to MAES App'))

      visit rewards_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit new_reward_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_reward_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_reward_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # access admin activities page without loggin in
    it 'not logging in, trying to access admin activities page' do
      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit activities_path
      expect(page).to(have_content('Log in to MAES App'))

      visit activity_path(id: activity.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit new_activity_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_activity_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_activity_path(id: reward.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin assign points without loggin in
    it 'not logging in, trying to access admin assigning points page' do
      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit member_points_path
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access admin users without logging in
    it 'not logging in, trying to access admin users page' do
      visit admin_dashboard_path
      expect(page).to(have_content('Log in to MAES App'))

      visit new_user_path
      expect(page).to(have_content('Log in to MAES App'))

      visit edit_user_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit delete_user_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access member dashboard without logging in
    it 'not logging in and try to get to member dashboard page' do
      visit member_dashboard_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # access members rewards page without loggin in
    it 'not loggin in, trying to access members rewards page' do
      visit member_dashboard_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit memrewards_path_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit memshow_path_path(id: reward.id, user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit handle_purchase_path(id: reward.id, user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access members account information without logging in
    it 'not logging in, trying to access members my account page' do
      visit member_dashboard_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit user_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))
    end

    # attempt to access members activity and reward history without logging in
    it 'not logging in, trying to access members history page' do
      visit member_dashboard_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))

      visit user_history_activity_path(user_id: user.id)
      expect(page).to(have_content('Log in to MAES App'))
    end
  end
end
