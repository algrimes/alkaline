module WeatherService
  
  require 'open-uri'
  
  def self.latest
    current_temp_page = CurrentTempPage.new(Nokogiri::HTML(open('http://www.bom.gov.au/products/IDV60901/IDV60901.95936.shtml')))
    forecast_page = ForecastPage.new(Nokogiri::HTML(open('http://www.bom.gov.au/vic/forecasts/melbourne.shtml')))
    { 
      "current_temp" => current_temp_page.current_temp,
      "today_max" => forecast_page.today_max,
      "tomorrow_max" => forecast_page.tomorrow_max
    }
  end
  
  private 
  
  class CurrentTempPage
    
    attr_accessor :current_temp_page
    
    def initialize current_temp_page
      @current_temp_page = current_temp_page
    end
    
    def current_temp
      current_temp_page.css('td[headers=\'t1-temp\']')[0].text
    end
    
  end
  
  class ForecastPage
    
    attr_accessor :forecast_page
    
    def initialize forecast_page
      @forecast_page = forecast_page
    end
    
    def today_max
      temp = forecast_page.css('#content div:nth-of-type(1) .forecast .max')
      temp.nil? ? "" : temp.text
    end
    
    def tomorrow_max
      temp = forecast_page.css('#content div:nth-of-type(2) .forecast .max')
      temp.nil? ? "" : temp.text
    end
    
  end
  
  
end