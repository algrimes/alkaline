module WeatherService
  
  require 'open-uri'
  require 'json'
  
  def self.latest
    observations = Observations.new(JSON.parse(open('http://www.bom.gov.au/fwo/IDV60901/IDV60901.95936.json').read))
    forecast_page = ForecastPage.new(Nokogiri::HTML(open('http://www.bom.gov.au/vic/forecasts/melbourne.shtml')))
    { 
      "current_temp" => observations.current_temp,
      "highest_temp" => observations.highest_temp,
      "today_max" => forecast_page.today_max,
      "tomorrow_max" => forecast_page.tomorrow_max,
      "today_chance_of_rain" => forecast_page.today_chance_of_rain,
      "tomorrow_chance_of_rain" => forecast_page.tomorrow_chance_of_rain
    }
  end
  
  private 
  
  class Observations
    
    def initialize observations
      @observations = observations["observations"]
    end
    
    def highest_temp
      @observations["data"].map { |o| o["air_temp"] if o["local_date_time"][0..1].to_i == Time.now.day }.compact.max
    end
    
    def current_temp
      @observations["data"][0]["air_temp"]
    end

  end
  
  class ForecastPage
    
    attr_accessor :forecast_page
    
    def initialize forecast_page
      @forecast_page = forecast_page
    end
    
    def today_max
      temp = forecast_page.css('#content div:nth-of-type(1) .forecast .max')
      temp.nil? ? "unknown" : temp.text
    end
    
    def today_chance_of_rain
      forecast_page.css('.rain .pop')[0].text
    end
    
    def tomorrow_chance_of_rain
      rain = forecast_page.css('.rain .pop')[1]
      rain.nil? ? "unknown" : rain.text
    end
    
    def tomorrow_max
      temp = forecast_page.css('#content div:nth-of-type(2) .forecast .max')
      temp.nil? ? "unknown" : temp.text
    end
    
  end
  
  
end