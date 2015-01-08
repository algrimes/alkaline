class DashboardController < ApplicationController
  
  
  def index
    require 'open-uri'
    current_temp_page = Nokogiri::HTML(open('http://www.bom.gov.au/products/IDV60901/IDV60901.95936.shtml'))

    
    
    forecast_page = Nokogiri::HTML(open('http://www.bom.gov.au/vic/forecasts/melbourne.shtml'))
   
    @view = { "current_temp" => current_temp_page.css('td[headers=\'t1-temp\']')[0].text, 
      "tomorrow_max" => forecast_page.css('#content div:nth-of-type(2) .forecast .max').text,
      "today_max" => forecast_page.css('#content div:nth-of-type(1) .forecast .max').text
    }
  end
end
