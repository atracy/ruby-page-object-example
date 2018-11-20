class OctLandingPage
  include Capybara::DSL
  include RSpec::Matchers

  def open_menu
    page.find[:css, "a[id='mobile-nav-link']"].click
  end
end
