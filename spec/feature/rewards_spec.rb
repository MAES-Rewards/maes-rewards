# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Viewing rewards', type: :feature) do
  context 'as member' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'John Doe' }
      }
                                                                        )

      User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: false)
      reward = Reward.create!(name: 'Sample Reward', point_value: 50, inventory: 10, dollar_price: 1.99)

    end

    it 'user logs in with Google as member & views rewards' do


      visit new_admin_session_path

      click_on 'Sign in via Google'

      click_on 'Rewards'

      # Assuming there is some delay or asynchronous operation happening
      # If content doesn't appear immediately, wait for it
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
    end

    it 'user logs in with Google as member & views reward details successfully' do


      visit new_admin_session_path

      click_on 'Sign in via Google'

      click_on 'Rewards'

      # Assuming rewards are listed on the page
      expect(page).to(have_content('Sample Reward'))

      click_on 'See details'

      expect(page).to(have_content('Sample Reward details'))
      expect(page).to(have_content('Sample Reward'))
      expect(page).to(have_content('50'))
      expect(page).to(have_content('1.99'))
      expect(page).to(have_content('10'))

      reward.destroy
    end

    it 'user logs in with Google as member & purchasing reward successfully' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      click_on 'Rewards'
      # Assuming rewards are listed on the page
      expect(page).to(have_content('Sample Reward'))

      click_on 'Purchase'

      click_on 'Confirm'

      expect(page).to(have_content('Reward was successfully purchased'))
      # new inventory
      expect(page).to(have_content('9'))

      click_on 'My Account'
      # new points
      expect(page).to(have_content('50'))
    end

    context 'when user has insufficient points' do
      before do
        User.find_by(email: 'user@tamu.edu').update!(points: 20)
      end

      it 'user logs in with Google as member & attempts purchase with insufficient point earnings' do
        visit new_admin_session_path

        click_on 'Sign in via Google'

        click_on 'Rewards'
        # Assuming rewards are listed on the page
        expect(page).to(have_content('Sample Reward'))

        click_on 'Purchase'

        click_on 'Confirm'

        expect(page).to(have_content('Reward is out of stock or user does not have sufficient points.'))
      end
    end

    context 'when reward has insufficient inventory' do
      before do
        User.find_by(email: 'user@tamu.edu').update!(points: 50)
        Reward.find_by(name: 'Sample Reward').update!(inventory: 0)
      end

      it 'user logs in with Google as member & attempts purchase on reward with insufficient inventory' do
        # Assuming you have a user created with the same email
        visit new_admin_session_path

        click_on 'Sign in via Google'

        click_on 'Rewards'

        # Assuming rewards are listed on the page
        expect(page).to(have_content('Sample Reward'))

        click_on 'Purchase'

        click_on 'Confirm'

        expect(page).to(have_content('Reward is out of stock or user does not have sufficient points.'))
      end
    end
  end

  context 'as admin' do
    it 'user logs in with Google as admin & views rewards' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'

      # Assuming there is some delay or asynchronous operation happening
      # If content doesn't appear immediately, wait for it
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
    end

    it 'user logs in with Google & creates reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      visit new_reward_path

      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      visit rewards_path

      expect(page).to(have_content('Test Reward'))
      expect(page).to(have_content('10'))
      expect(page).to(have_content('20.99'))
      expect(page).to(have_content('50'))

      # Assuming there is some delay or asynchronous operation happening
      # If content doesn't appear immediately, wait for it
    end

    it 'admin logs in with Google & creates then deletes reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      visit new_reward_path

      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      visit rewards_path

      click_on 'Delete'

      click_on 'Delete Reward'

      expect(page).not_to(have_content('Test Reward'))
      expect(page).to(have_content('Reward was successfully deleted'))
    end

    it 'admin logs in with Google & creates then edits reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      visit new_reward_path

      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      visit rewards_path

      click_on 'Edit'

      fill_in 'reward[name]', with: 'Edited Reward'

      click_on 'Save changes'

      expect(page).to(have_content('Edited Reward'))
      expect(page).to(have_content('Reward was successfully updated.'))
    end

    it 'admin logs in with Google & creates then views reward details' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      visit new_reward_path

      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      visit rewards_path

      click_on 'See details'
      expect(page).to(have_content('Detailed view'))
      expect(page).to(have_content('Test Reward'))
      expect(page).to(have_content('10'))
      expect(page).to(have_content('20.99'))
      expect(page).to(have_content('50'))
    end
  end
end
