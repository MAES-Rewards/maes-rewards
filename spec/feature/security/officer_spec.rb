# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Testing Security', type: :feature) do
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

    # Officer Login Sunny Day Test
    it 'logins in to the website using Google OAuth' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      expect(page).to(have_content('Home'))
    end

    # Officer Home Sunny Day Test
    it 'logins in to the website and presses home' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      expect(page).to(have_content('Home'))

      click_on 'Home'

      expect(page).to(have_content('Home'))
    end

    # Officer Rewards Sunny Day Tests
    it 'logins in to the website and presses rewards' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      expect(page).to(have_content('Home'))

      click_on 'Rewards'

      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Add New Reward'))
    end

    it 'logins in to the website, navigate to rewards, and presses adds new reward' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Rewards'

      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Add New Reward'))

      click_on 'Add New Reward'
      expect(page).to(have_content('Create New Reward'))
      expect(page).to(have_content('Create Reward'))
      expect(page).to(have_content('Name'))
    end

    it 'logins in to the website, navigate to rewards, and presses see details' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Rewards'

      expect(page).to(have_content('Rewards'))

      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Add New Reward'))

      within('tr', text: 'Sample Reward') do
        click_on 'See details'
      end

      expect(page).to(have_content('Sample Reward'))
      expect(page).to(have_content('Back to all Rewards'))
      expect(page).to(have_content('50'))
    end

    it 'logins in to the website, navigate to rewards, look at reward details, and presses edit' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Rewards'

      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Add New Reward'))

      within('tr', text: 'Sample Reward') do
        click_on 'See details'
      end

      expect(page).to(have_content('Sample Reward'))
      expect(page).to(have_content('Back to all Rewards'))
      expect(page).to(have_content('Sample Reward'))

      click_on 'Edit'
      expect(page).to(have_content('Edit Reward: Sample Reward'))
      expect(page).to(have_content('Name'))
    end

    it 'logins in to the website, navigate to rewards, and presses delete' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Rewards'

      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Add New Reward'))

      click_on 'Delete'
      expect(page).to(have_content('Delete reward: Sample Reward'))
      expect(page).to(have_content('Are you sure you want to permanently delete this reward?'))
      expect(page).to(have_content('Sample Reward'))
    end

    # Officer Activities Sunny Day Tests
    it 'logins in to the website and presses activities' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Activities'
      expect(page).to(have_content('Activities'))
      expect(page).to(have_content('Add New Activity'))
      expect(page).to(have_content('Sample Activity'))
    end

    it 'presses add new activity' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Activities'
      expect(page).to(have_content('Activities'))
      expect(page).to(have_content('Add New Activity'))
      expect(page).to(have_content('Sample Activity'))

      click_on 'Add New Activity'
      expect(page).to(have_content('Create Activity'))
      expect(page).to(have_content('Back to all Activities'))
      expect(page).to(have_content('Name'))
    end

    it 'presses show activity' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Activities'
      expect(page).to(have_content('Activities'))
      expect(page).to(have_content('Add New Activity'))
      expect(page).to(have_content('Sample Activity'))

      within('tr', text: 'Sample Activity') do
        click_on 'See Details'
      end

      expect(page).to(have_content('Sample Activity'))
      expect(page).to(have_content('This is an activity'))
    end

    it 'logins in to the website, navigates to activities, and presses add new activity' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Activities'
      expect(page).to(have_content('Activities'))
      expect(page).to(have_content('Add New Activity'))
      expect(page).to(have_content('Sample Activity'))

      within('tr', text: 'Sample Activity') do
        click_on 'See Details'
      end

      expect(page).to(have_content('Sample Activity'))
      expect(page).to(have_content('This is an activity'))

      click_on 'Edit'
      expect(page).to(have_content('Edit activity: Sample Activity'))
      expect(page).to(have_content('Back to all Activities'))
      expect(page).to(have_content('Description'))
    end

    it 'presses delete activity' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Activities'
      expect(page).to(have_content('Activities'))
      expect(page).to(have_content('Add New Activity'))
      expect(page).to(have_content('Sample Activity'))

      within('tr', text: 'Sample Activity') do
        click_on 'Delete'
      end
      expect(page).to(have_content('Delete activity: Sample Activity'))
      expect(page).to(have_content('Are you sure you want to permanently delete this activity?'))
      expect(page).to(have_content('Sample Activity'))
    end

    # Officer Assign Points Sunny Day Tests
    it 'presses assign points' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Assign Points'
      expect(page).to(have_content('Assign Points to Members'))
      expect(page).to(have_content('Member List'))
      expect(page).to(have_content('Associated Recurring Activity:'))
    end

    # Officer Notifications Sunny Day Tests
    it 'presses notifications' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Notifications'
      expect(page).to(have_content('Reward Notifications'))
      expect(page).to(have_content('All reward purchases made in the last 24 hours are listed here.'))
    end

    # Officer Help Sunny Day Tests
    it 'presses help on officer page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Home'))

      click_on 'Help'
      expect(page).to(have_content('Documentation'))
      expect(page).to(have_content('Officer Help'))
      expect(page).to(have_content('When an event occurs, points can be awarded in bulk through the Assign Points page. Users can be easily checked off, and officers can search the list as well as only display selected users. When the form is submitted, all users will be given the specified amount of points associated with the specified activity. There is also a Custom One-Time Activity option, where a custom activity can be entered for the transaction records without having to create a new activity.'))
    end

    # Officer Sign Out Sunny Day Test
    it 'log out of website' do
      visit new_admin_session_path

      click_on 'Sign Out'
      expect(page).to(have_content('Log in to MAES App'))
    end
  end
end
