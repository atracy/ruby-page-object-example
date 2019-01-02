class GoogleLandingPage
  include Capybara::DSL
  include RSpec::Matchers

  def enter_search_text(search_text)
    page.find("input[name='q']").set search_text
  end

  def click_search
    page.click_on 'Google Search'
  end
end
