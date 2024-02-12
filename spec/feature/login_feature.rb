require 'rails_helper'

RSpec.describe('Google OAuth login', type: :feature) do
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

  it 'user logs in with Google' do
    visit new_admin_session_path
    click_on 'Sign in via Google'

    # Assuming there is some delay or asynchronous operation happening
    # If content doesn't appear immediately, wait for it
    expect(page).to(have_content('Welcome, John Doe!'))
  end
end
