require 'selenium-webdriver'
require 'capybara/rspec'

Capybara.register_driver :headless_chrome do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.args << '--headless'
  chrome_options.args << '--no-sandbox'

  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
  driver
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 5
Capybara.server = :puma, { Silent: true }