# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Reward Notifications', type: :feature) do
  let!(:user1) { User.create!(email: 'jbeeber@tamu.edu', name: 'James Beeber', points: 100, is_admin: true) }
  let!(:user2) { User.create!(email: 'rose@tamu.edu', name: 'Rose Vueee', points: 50, is_admin: false) }
  let!(:reward) { Reward.create!(name: 'MAES Hoodie', point_value: 20, dollar_price: 50, inventory: 5) }
  let!(:recent_purchase) { SpendTransaction.create!(reward: reward, user: user2, created_at: 1.hour.ago) }
  let!(:old_purchase) { SpendTransaction.create!(reward: reward, user: user2, created_at: 2.days.ago) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: 'jbeeber@tamu.edu',
        name: 'James Beeber'
      }
    }
                                                                      )
    page.set_rack_session(user_id: user1.id, is_admin: true)
  end

  context 'As an officer' do
    it 'can see new reward purchases' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      expect(page).to(have_content('Admin Home'))

      click_on 'Notifications'
      expect(page).to(have_content('Reward Notifications'))

      expect(page).to(have_content('MAES Hoodie'))
      expect(page).to(have_content(user2.name))
      expect(page).to(have_content(recent_purchase.created_at.strftime('%Y-%m-%d %H:%M:%S')))
      expect(page).not_to(have_content(old_purchase.created_at.strftime('%Y-%m-%d %H:%M:%S')))
    end

    it 'can mark a reward purchase as given' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      expect(page).to(have_content('Admin Home'))

      click_on 'Notifications'
      expect(page).to(have_content('Reward Notifications'))

      within(find('tr', text: user2.name)) do
        find('input[type="checkbox"]').set(true)
      end

      within(find('tr', text: user2.name)) do
        checkbox_id = find('input[type="checkbox"]')[:id]
        expect(page).to(have_checked_field(checkbox_id))
      end
    end

    it 'can unmark a reward purchase as not given' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      expect(page).to(have_content('Admin Home'))

      click_on 'Notifications'
      expect(page).to(have_content('Reward Notifications'))

      within(find('tr', text: user2.name)) do
        find('input[type="checkbox"]').set(false)
      end

      within(find('tr', text: user2.name)) do
        checkbox_id = find('input[type="checkbox"]')[:id]
        expect(page).to(have_unchecked_field(checkbox_id))
      end
    end
  end
end
