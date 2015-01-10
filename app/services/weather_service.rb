module WeatherService
  
  require 'open-uri'
  
  def self.latest
    observations_page = ObservationsPage.new(Nokogiri::HTML(open('http://www.bom.gov.au/products/IDV60901/IDV60901.95936.shtml')))
    forecast_page = ForecastPage.new(Nokogiri::HTML(open('http://www.bom.gov.au/vic/forecasts/melbourne.shtml')))
    { 
      "current_temp" => observations_page.current_temp,
      "highest_temp" => observations_page.highest_temp,
      "today_max" => forecast_page.today_max,
      "tomorrow_max" => forecast_page.tomorrow_max,
      "today_chance_of_rain" => forecast_page.today_chance_of_rain,
      "tomorrow_chance_of_rain" => forecast_page.tomorrow_chance_of_rain
    }
  end
  
  private 
  
  class ObservationsPage
    
    attr_accessor :observations_page
    
    def initialize observations_page
      @observations_page = observations_page
    end
    
    def highest_temp
      today_temps.map { |temp| temp.text }.max
    end
    
    def current_temp
      today_temps[0].text
    end
    
    private 
    
    def today_temps
      observations_page.css("table#t1 td[headers=\'t1-temp\']")
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
    
    def today_chance_of_rain
      forecast_page.css('.rain .pop')[0].text
    end
    
    def tomorrow_chance_of_rain
      forecast_page.css('.rain .pop')[1].text
    end
    
    def tomorrow_max
      temp = forecast_page.css('#content div:nth-of-type(2) .forecast .max')
      temp.nil? ? "" : temp.text
    end
    
  end
  
  
end