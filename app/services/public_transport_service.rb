module PublicTransportService

  @ptv_api = PTVApi.new(Rails.application.config.ptv_dev_id, Rails.application.config.ptv_security_key)
  
  @tram_stop = Stop.new({"stop_id" => Rails.application.config.nearest_train_stop, "transport_type" => "train"})

  def self.next_tram_departures
    departures = @ptv_api.broad_next_departures @tram_stop, 5
    departures.collect { |departure| 
      { 
        "destination" => departure.run.destination_name, 
        "departing_in" => TimeDifference.between(Time.now, departure.time.localtime).in_minutes.to_i.to_s + " minutes" 
      } 
    }
  end

end
