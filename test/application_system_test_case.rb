require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 900 ]

  setup do
    # React SPA takes time to mount after the HTML shell loads. A global wait
    # means every assertion retries for up to this long — passing tests still
    # exit as soon as the condition is met, so the suite isn't meaningfully slower.
    Capybara.default_max_wait_time = 10
  end
end
