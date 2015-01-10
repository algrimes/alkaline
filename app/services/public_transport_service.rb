module PublicTransportService

  @ptv_api = PTVApi.new(Rails.application.config.ptv_dev_id, Rails.application.config.ptv_security_key)
  
  @stop = Stop.new({"stop_id" => Rails.application.config.nearest_train_stop, "transport_type" => "train"})

  def self.train_departures
    departures = @ptv_api.broad_next_departures @stop, 5
    departure_vms = departures.map { |d| departure_viewmodel d }
    
    to_city, rest = departure_vms.partition { |departure|
      departure["destination"] == "Flinders Street"
    }
    
    { "city_trains" => to_city, "rest" => rest.take(5) }
  end
    
  private 
    
  def self.departure_viewmodel departure  
   { 
      "destination" => departure.run.destination_name, 
      "departing_in" => TimeDifference.between(Time.now, departure.time.localtime).in_minutes.to_i.to_s + " minutes",
      "departure_time" => departure.time.to_s(:time)
   } 
  end

end
