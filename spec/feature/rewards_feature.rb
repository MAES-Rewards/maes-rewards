require 'rails_helper'

RSpec.describe('Viewing rewards', type: :feature) do
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

  it 'user logs in with Google & views rewards' do
    visit new_admin_session_path
    click_on 'Sign in via Google'
    click_on 'View Rewards'

    # Assuming there is some delay or asynchronous operation happening
    # If content doesn't appear immediately, wait for it
    expect(page).to(have_content('All of the rewards that can be purchased with points are shown below.'))
  end
end

RSpec.describe('Creating rewards', type: :feature) do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: 'ahartman03@tamu.edu',
        name: 'Sally Doe'
      }
    }
                                                                      )
    Capybara.current_driver = :selenium
    Capybara.default_max_wait_time = 10 # Adjust the wait time as needed
  end

  it 'user logs in with Google & creates reward' do
    visit new_admin_session_path
    click_on 'Sign in via Google'
    visit admin_dashboard_path
    click_on 'View Rewards'
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
end

RSpec.describe('Deleting rewards', type: :feature) do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: 'ahartman03@tamu.edu',
        name: 'Sally Doe'
      }
    }
                                                                      )
    Capybara.current_driver = :selenium
    Capybara.default_max_wait_time = 10 # Adjust the wait time as needed
  end

  it 'user logs in with Google & creates then deletes reward' do
    visit new_admin_session_path
    click_on 'Sign in via Google'
    visit admin_dashboard_path
    click_on 'View Rewards'
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
end

# RSpec.describe('Creating a reward', type: :feature) do
#   it 'valid inputs' do
#     visit new_reward_path
#     fill_in 'reward[name]', with: 'Test Reward'
#     fill_in 'reward[point_value]', with: 10
#     fill_in 'reward[dollar_price]', with: 20.99
#     fill_in 'reward[inventory]', with: 50
#     click_on 'Create Reward'
#     visit rewards_path
#     expect(page).to(have_content('Reward was successfully created.'))
#     expect(page).to(have_content('Test Reward'))
#     expect(page).to(have_content('10'))
#     expect(page).to(have_content('20.99'))
#     expect(page).to(have_content('50'))
#   end
# end

# RSpec.describe('Creating a blank reward', type: :feature) do
#   it 'blank inputs' do
#     visit new_reward_path
#     click_on 'Create Reward'
#     expect(page).to(have_content('Reward could not be created. Attribute(s) are invalid.'))
#   end
# end
