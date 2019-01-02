require 'spec_helper'
google = Google.new

feature 'Search Shazam', type: :acceptance, sauce: ENV['USESAUCE'] do
  before do
    visit(google.url('google'))
  end

  scenario 'Search for Shazam' do
    google.landing_page.enter_search_text 'Shazam'
    google.landing_page.click_search
  end
end
