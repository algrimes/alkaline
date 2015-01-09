class DashboardController < ApplicationController

  include ::WeatherService
  include ::PublicTransportService

  def index
    @view = { "weather" => WeatherService.latest, "transport" => PublicTransportService.next_tram_departures }
  end
  
end
