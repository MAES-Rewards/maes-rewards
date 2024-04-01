frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Admins editing, deleting, and viewing users', type: :feature) do
  let!(:user) { User.create!(email: 'user@tamu.edu', name: 'James Doe', points: 100, is_admin: false) }


  context 'Admin logs in and edits user' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'user@tamu.edu', name: 'Admin Doe' }
      })
      page.set_rack_session(user_id: user.id, is_admin: true)
      User.create!(email: 'user1@tamu.edu', name: 'Jim Doe', points: 100, is_admin: false)
      User.create!(email: 'user@tamu.edu', name: 'John Doe', points: 100, is_admin: false)
      User.create!(email: 'user2@tamu.edu', name: 'Jane Doe', points: 10, is_admin: false)
    end

    it 'Attempts to edit user unsuccessfully' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Home'

      expect(page).to(have_content('All Members'))
      expect(page).to(have_content('Jim Doe'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      within('tr', text: 'Jim Doe') do
        click_on 'Edit'
      end

      fill_in 'user[name]', with: 'Jimmy Doe'
      fill_in 'user[points]', with: -10_000_000

      click_on 'Save changes'

      expect(page).to(have_content('User could not be updated. Attribute(s) are invalid.'))
    end

    it 'Edits user successfully' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Home'

      expect(page).to(have_content('All Members'))
      expect(page).to(have_content('Jim Doe'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      within('tr', text: 'Jane Doe') do
        click_on 'Edit'
      end

      fill_in 'user[name]', with: 'Janey Appleseed Doe'
      fill_in 'user[points]', with: 1000

      click_on 'Save changes'

      expect(page).to(have_content('User was successfully updated.'))
      expect(page).to(have_content('Janey Appleseed Doe'))
    end

    it 'Deletes user successfully' do
      visit new_admin_session_path
      click_on 'Sign in via Google'
      visit set_admin_session_path
      visit admin_dashboard_path

      click_on 'Home'

      expect(page).to(have_content('All Members'))
      expect(page).to(have_content('Jim Doe'))
      expect(page).to(have_content('John Doe'))
      expect(page).to(have_content('Jane Doe'))

      within('tr', text: 'Jane Doe') do
        click_on 'Delete'
      end

      expect(page).to(have_content('Delete member account'))
      expect(page).to(have_content('Are you sure you want to permanently delete this account?'))
      expect(page).to(have_content('Name: John Doe'))

      click_on 'Delete account'

      expect(page).to(have_content('User successfully deleted.'))
      expect(page).not_to(have_content('Jane Doe'))
    end
  end
end
