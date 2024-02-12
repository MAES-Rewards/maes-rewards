# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Activity MEMBER login', type: :feature) do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: 'user@tamu.edu',
        name: 'John Doe'
      }
    }
                                                                      )
    Capybara.current_driver = :selenium
    Capybara.default_max_wait_time = 10 # Adjust the wait time as needed
  end

  it 'member user logs in with Google to new activity page' do
    visit new_admin_session_path
    click_on 'Sign in via Google'
    visit new_activity_path
    expect(page).to(have_content('Access denied'))
  end
end

RSpec.describe('Activity ADMIN login', type: :feature) do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '12345',
      info: {
        email: 'jbeeber@tamu.edu',
        name: 'James Beeber'
      }
    }
                                                                      )
    Capybara.current_driver = :selenium

    Capybara.default_max_wait_time = 10 # Adjust the wait time as needed
  end

  it 'admin user logs in with Google and creates, edits, and deletes activity' do
    # gets(:omniauth_callbacks, session: { is_admin: true })

    visit new_admin_session_path
    click_on 'Sign in via Google'
    visit set_admin_session_path

    visit new_activity_path

    fill_in 'activity[name]', with: 'Test Activity'
    fill_in 'activity[description]', with: 'Test Description'
    fill_in 'activity[default_points]', with: 100
    click_on 'Create Activity'

    visit activities_path
    expect(page).to(have_content('Test Activity'))

    visit activity_path(Activity.last)
    expect(page).to(have_content('Test Activity'))
    expect(page).to(have_content('Edit'))
    expect(page).to(have_content('Delete'))

    click_on 'Delete'
    expect(page).to(have_content('Are you sure'))
    click_on 'Delete Activity'
    expect(page).to(have_content('Activity was successfully deleted'))
    expect(page).not_to(have_content('Test Activity'))
  end
end
