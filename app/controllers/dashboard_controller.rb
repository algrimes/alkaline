class DashboardController < ApplicationController

  include ::WeatherService
  include ::PublicTransportService

  def index
    @view = { "weather" => WeatherService.latest, "transport" => PublicTransportService.train_departures }
  end
  
end
