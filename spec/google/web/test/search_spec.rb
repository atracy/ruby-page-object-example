require 'spec_helper'
google = Google.new

feature 'Search Muramasa', type: :acceptance, sauce: ENV['USESAUCE'] do
  before do
    visit(octanner.utilities.url('google'))
  end

  scenario 'Search' do
    google.landing_page.enter_search_text('Muramasa')
    google.landing_page.click_search
  end
end
