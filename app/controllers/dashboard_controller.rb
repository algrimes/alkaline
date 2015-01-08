class DashboardController < ApplicationController

  include ::WeatherService

  def index
    @view = WeatherService.latest
  end
  
end
