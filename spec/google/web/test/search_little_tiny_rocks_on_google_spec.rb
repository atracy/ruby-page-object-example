require 'spec_helper'
google = Google.new

feature 'Search Little Tiny Rocks', type: :acceptance, sauce: ENV['USESAUCE'] do
  before do
    visit(google.url('google'))
  end

  scenario 'Search for Little Tiny Rocks' do
    google.landing_page.enter_search_text 'Little Tiny Rocks'
    google.landing_page.click_search
  end
end
