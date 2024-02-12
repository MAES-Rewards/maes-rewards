require 'rails_helper'

RSpec.describe('Google OAuth MEMBER login', type: :feature) do
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

  it 'user logs in with Google to member page' do
    visit new_admin_session_path
    click_on 'Sign in via Google'

    # Assuming there is some delay or asynchronous operation happening
    # If content doesn't appear immediately, wait for it
    expect(page).to(have_content('Welcome, John Doe!'))
  end
end

RSpec.describe('Google OAuth ADMIN login', type: :feature) do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '12345',
      info: {
        email: 'ahartman03@tamu.edu',
        name: 'Anna Hartman'
      }
    }
                                                                      )
    Capybara.current_driver = :selenium
    Capybara.default_max_wait_time = 10 # Adjust the wait time as needed
  end

  it 'user logs in with Google into admin page' do
    visit new_admin_session_path
    click_on 'Sign in via Google'
    visit admin_dashboard_path
    # Assuming there is some delay or asynchronous operation happening
    # If content doesn't appear immediately, wait for it
    expect(page).to(have_content('ADMIN Page'))
    expect(page).to(have_content('Activities'))
    # Activities is only displayed for Admin.
  end
end
