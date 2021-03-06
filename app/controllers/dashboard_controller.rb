class DashboardController < ApplicationController

  include ::WeatherService
  include ::PublicTransportService
  include ::CurrencyService
  include ::EventsService

  def index
    @view = { 
      "weather" => WeatherService.latest, 
      "transport" => PublicTransportService.train_departures, 
      "currency" => { "aud_gbp" => CurrencyService.aud_to_gbp, "gbp_aud" => CurrencyService.gbp_to_aud },
      "events" => EventsService.today
    }
  end
  
end
