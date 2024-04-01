# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Testing Member Usability with Clicks', type: :feature) do
  let!(:user) { User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: false) }
  let!(:other_user) { User.create!(email: 'other_user@tamu.edu', name: 'James James', points: 100, is_admin: false) }

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

    # Member Rewards Click Test
    it 'logins to the website and views the rewards page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      counter = 0

      click_on 'View Rewards'
      counter += 1
      expect(page).to(have_content('Rewards'))
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))

      expect(counter).to(be <= 2)
    end

    # Member Account Click Test
    it 'logins to the website and views their respective account page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      counter = 0

      click_on 'My Account'
      counter += 1
      expect(page).to(have_content('My Account'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('user@tamu.edu'))

      expect(counter).to(be <= 2)
    end

    # Member History Click Test
    it 'logins to the website and views their respective transaction history' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      counter = 0

      click_on 'View My History'
      counter += 1
      expect(page).to(have_content('All of the activites you have participated in are shown below.'))
      expect(page).to(have_content('Activity History'))

      expect(counter).to(be <= 2)
    end

    # Member Help Click Test
    it 'logins to the website and views the help page' do
      visit new_admin_session_path

      click_on 'Sign in via Google'
      expect(page).to(have_content('Member Home: Welcome, John Doe!'))
      counter = 0

      click_on 'Help'
      counter += 1
      expect(page).to(have_content('Documentation'))
      expect(page).to(have_content('Member Help'))
      expect(page).to(have_content('With the MAES Rewards app, MAES members can complete activities, earn points, and spend them on rewards!'))

      expect(counter).to(be <= 2)
    end
  end
end
