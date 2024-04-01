# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Viewing rewards', type: :feature) do
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
      Reward.create!(name: 'Sample Reward', point_value: 50, inventory: 10, dollar_price: 1.99)
    end

    it 'user logs in with Google as member & views rewards' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      click_on 'View Rewards'

      # Assuming there is some delay or asynchronous operation happening
      # If content doesn't appear immediately, wait for it
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
    end

    it 'user logs in with Google as member & views reward details successfully' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      click_on 'View Rewards'
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))

      # Assuming rewards are listed on the page
      expect(page).to(have_content('Sample Reward'))

      click_on 'See details'

      expect(page).to(have_content('Sample Reward'))
      expect(page).to(have_content('50'))
      expect(page).to(have_content('1.99'))
      expect(page).to(have_content('10'))
    end

    it 'user logs in with Google as member & purchases reward successfully' do
      visit new_admin_session_path

      click_on 'Sign in via Google'

      click_on 'Rewards'
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      # Assuming rewards are listed on the page
      expect(page).to(have_content('Sample Reward'))

      click_on 'Purchase'

      expect(page).to(have_content('Are you sure you want to purchase this reward?'))
      expect(page).to(have_content('Sample Reward'))

      click_on 'Confirm'

      expect(page).to(have_content('Reward was successfully purchased'))
      # new inventory
      expect(page).to(have_content('9'))

      click_on 'My Account'
      # new points
      expect(page).to(have_content('50'))
    end

    context 'user attempts to purchase reward with insufficient points' do
      before do
        User.find_by(email: 'user@tamu.edu').update!(points: 20)
        page.set_rack_session(user_id: user.id, is_admin: false)
      end

      it 'user logs in with Google as member & attempts purchase with insufficient point earnings' do
        visit new_admin_session_path

        click_on 'Sign in via Google'

        click_on 'Rewards'
        # Assuming rewards are listed on the page
        expect(page).to(have_content('Sample Reward'))

        click_on 'Purchase'

        expect(page).to(have_content('Are you sure you want to purchase this reward?'))
        expect(page).to(have_content('Sample Reward'))

        click_on 'Confirm'

        expect(page).to(have_content('Reward is out of stock or user does not have sufficient points.'))
      end
    end

    context 'user attemtps to purchase reward that has insufficient inventory' do
      before do
        User.find_by(email: 'user@tamu.edu').update!(points: 50)
        Reward.find_by(name: 'Sample Reward').update!(inventory: 0)
        page.set_rack_session(user_id: user.id, is_admin: false)
      end

      it 'user logs in with Google as member & attempts purchase on reward with insufficient inventory' do
        # Assuming you have a user created with the same email
        visit new_admin_session_path

        click_on 'Sign in via Google'

        click_on 'Rewards'

        # Assuming rewards are listed on the page
        expect(page).to(have_content('Sample Reward'))

        click_on 'Purchase'

        expect(page).to(have_content('Are you sure you want to purchase this reward?'))
        expect(page).to(have_content('Sample Reward'))

        click_on 'Confirm'

        expect(page).to(have_content('Reward is out of stock or user does not have sufficient points.'))
      end
    end
  end

  context 'as admin' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'John Doe' }
      }
                                                                        )
      page.set_rack_session(user_id: user.id, is_admin: true)
      Reward.create!(name: 'Hoodie', point_value: 20, inventory: 15, dollar_price: 29.99)
      page.set_rack_session(is_admin: true)
    end

    it 'user logs in with Google & views existing reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Hoodie'))
      within('tr', text: 'Hoodie') do
        click_on 'See details'
      end

      expect(page).to(have_content('Hoodie'))
      expect(page).to(have_content('20'))
      expect(page).to(have_content('15'))
      expect(page).to(have_content('29.99'))
      expect(page).to(have_content('Name'))
      expect(page).to(have_content('Dollar price'))
      expect(page).to(have_content('Point price'))
      expect(page).to(have_content('Current inventory'))
      expect(page).to(have_content('Created'))
      expect(page).to(have_content('Updated'))


    end

    it 'user logs in with Google & edits existing reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Hoodie'))
      within('tr', text: 'Hoodie') do
        click_on 'Edit'
      end

      expect(page).to(have_content('Edit Reward: Hoodie'))
      fill_in 'reward[name]', with: 'Lil Hoodie'
      fill_in 'reward[inventory]', with: '18'

      click_on 'Save changes'

      expect(page).to(have_content('Lil Hoodie'))
      expect(page).to(have_content('Reward was successfully updated.'))

    end

    it 'user logs in with Google & deletes existing reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
      expect(page).to(have_content('Hoodie'))
      within('tr', text: 'Hoodie') do
        click_on 'Delete'
      end

      expect(page).to(have_content('Delete reward: Hoodie'))
      expect(page).to(have_content('Are you sure you want to permanently delete this reward?'))

      click_on 'Delete Reward'

      expect(page).not_to(have_content('Hoodie'))
      expect(page).to(have_content('Reward was successfully deleted'))

    end

    it 'user logs in with Google as admin & views rewards' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'

      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))

    end

    it 'user logs in with Google & creates reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path
      click_on 'Rewards'
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))

      click_on 'Add New Reward'

      expect(page).to(have_content('Create New Reward'))

      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      click_on 'Rewards'

      expect(page).to(have_content('Test Reward'))
      expect(page).to(have_content('10'))
      expect(page).to(have_content('20.99'))
      expect(page).to(have_content('50'))

    end

    it 'admin logs in with Google & creates then deletes reward' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Rewards'
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))

      click_on 'Add New Reward'
      expect(page).to(have_content('Create New Reward'))

      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      click_on 'Rewards'

      within('tr', text: 'Test Reward') do
        click_on 'Delete'
      end

      expect(page).to(have_content('Delete reward: Test Reward'))

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
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))

      click_on 'Add New Reward'
      expect(page).to(have_content('Create New Reward'))


      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      click_on 'Rewards'

      within('tr', text: 'Test Reward') do
        click_on 'Edit'
      end

      expect(page).to(have_content('Edit Reward: Test Reward'))

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
      expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))

      click_on 'Add New Reward'
      expect(page).to(have_content('Create New Reward'))

      fill_in 'reward[name]', with: 'Test Reward'
      fill_in 'reward[point_value]', with: 10
      fill_in 'reward[dollar_price]', with: 20.99
      fill_in 'reward[inventory]', with: 50
      click_on 'Create Reward'

      click_on 'Rewards'

      within('tr', text: 'Test Reward') do
        click_on 'See details'
      end

      expect(page).to(have_content('Name'))
      expect(page).to(have_content('Dollar price'))
      expect(page).to(have_content('Point price'))
      expect(page).to(have_content('Current inventory'))
      expect(page).to(have_content('Created'))
      expect(page).to(have_content('Updated'))

      expect(page).to(have_content('Test Reward'))
      expect(page).to(have_content('10'))
      expect(page).to(have_content('20.99'))
      expect(page).to(have_content('50'))
    end
  end
end
