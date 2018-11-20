class Google
  def landing_page
    @landing_page ||= GoogleLandingPage.new
  end
end
