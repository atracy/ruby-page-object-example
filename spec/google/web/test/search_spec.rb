require 'spec_helper'
google = Google.new

feature 'Search Muramasa', type: :acceptance, broken: true, sauce: ENV['USESAUCE'] do
  before do
    visit(blah.utilities.url('google'))
  end

  scenario 'Search' do
    google.landing_page.enter_search_text('Muramasa')
    google.landing_page.click_search
  end
end
