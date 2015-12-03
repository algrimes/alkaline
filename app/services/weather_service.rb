module WeatherService
  
  require 'open-uri'
  require 'json'
  require 'thread'
  
  def self.latest
    { 
      "current_temp" => @@observations.current_temp,
      "highest_temp" => @@observations.highest_temp,
      "today_max" => @@forecast.today_max,
      "tomorrow_max" => @@forecast.tomorrow_max,
      "today_chance_of_rain" => @@forecast.today_chance_of_rain,
      "tomorrow_chance_of_rain" => @@forecast.tomorrow_chance_of_rain
    }
  end
  
  def self.update_observations
    @@observation_result = Observations.new(JSON.parse(open('http://www.bom.gov.au/fwo/IDV60901/IDV60901.95936.json').read))
  end
  
  def self.update_forecast
    @@forecast = Forecast.new(Nokogiri::HTML(open('http://www.bom.gov.au/vic/forecasts/melbourne.shtml')))
  end
  

  
  
  mutex = Mutex.new
  
  Thread.new do
    loop do
      mutex.synchronize do
        self.update_observations
        self.update_forecast
        sleep 30
      end
    end
  end
  
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
  
  class Forecast
    
    def initialize forecast
      @forecast = forecast
    end
    
    def today_max
      temp = @forecast.css('#content div:nth-of-type(1) .forecast .max')
      temp.nil? ? "unknown" : temp.text
    end
    
    def today_chance_of_rain
      @forecast.css('.rain .pop')[0].text
    end
    
    def tomorrow_chance_of_rain
      rain = @forecast.css('.rain .pop')[1]
      rain.nil? ? "unknown" : rain.text
    end
    
    def tomorrow_max
      temp = @forecast.css('#content div:nth-of-type(2) .forecast .max')
      temp.nil? ? "unknown" : temp.text
    end
    
  end
  
  @@observations = self.update_observations
  @@forecast = self.update_forecast
  
end