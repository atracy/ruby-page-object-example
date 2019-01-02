require 'spec_helper'
google = Google.new

feature 'Search Ryan', type: :acceptance, sauce: ENV['USESAUCE'] do
  before do
    visit(google.url('google'))
  end

  scenario 'Search for Ryan' do
    google.landing_page.enter_search_text 'Ryan'
    google.landing_page.click_search
  end
end
