class DashboardController < ApplicationController
  
  
  def index
    require 'open-uri'
    page = Nokogiri::HTML(open('http://www.bom.gov.au/products/IDV60901/IDV60901.95936.shtml'))
    @view = { "temp" => page.css('td[headers=\'t1-temp\']')[0].text}
  end
end
