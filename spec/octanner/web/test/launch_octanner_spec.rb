require 'spec_helper'
octanner = Octanner.new

feature 'Launch OC Tanner Website', type: :acceptance, sauce: ENV['USESAUCE'] do
  before do
    visit(octanner.utilities.url('octanner'))
  end

  scenario 'open menu' do
    octanner.landing_page.open_menu
  end
end
