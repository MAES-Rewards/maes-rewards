# frozen_string_literal: true

Capybara.register_driver(:selenium_chrome) do |app|
  # Set chrome download dir and auto confirm all "are you sure you want to download" to test downloading docs and pdfs.
  chrome_prefs = {
    'download' => {
      'default_directory' => DownloadHelpers::PATH.to_s,
      'prompt_for_download' => false
    },
    'profile' => {
      'default_content_settings' => { 'multiple-automatic-downloads': 1 }, # for chrome version olde ~42
      'default_content_setting_values' => { automatic_downloads: 1 }, # for chrome newe 46
      'password_manager_enabled' => false
    },
    'safebrowsing' => {
      'enabled' => false,
      'disable_download_protection' => true
    }
  }

  # Set headless with docker friendly args.
  chrome_args = %w[window-size=1024,768 disable-gpu no-sandbox disable-translate no-default-browser-check disable-popup-blocking]
  # To run full browser instead of headless mode, run this command: HEADLESS=false rspec spec
  chrome_args += %w[headless] unless ENV.fetch('HEADLESS', 'true') == 'false'

  # Initialize chromedriver.
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      prefs: chrome_prefs,
      args: chrome_args
    }
  )
  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)

  driver
end
