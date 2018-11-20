require 'spec_helper'
google = Google.new

feature 'Search Muramasa', type: :acceptance, sauce: ENV['USESAUCE'] do
  before do
    visit(octanner.utilities.url('google'))
  end

  scenario 'Landing_Page' do
    google.landing_page.click_search
  end
end
