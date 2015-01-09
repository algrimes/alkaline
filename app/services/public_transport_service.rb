module PublicTransportService

  @ptv_api = PTVApi.new(Rails.application.config.ptv_dev_id, Rails.application.config.ptv_security_key)
  
  @tram_stop = Model::Stop.new({"stop_id" => Rails.application.config.nearest_tram_stop, "transport_type" => "tram"})

  def self.next_tram_departures
    departures = @ptv_api.broad_next_departures @tram_stop, 5
    departures["values"].collect { |v| 
      { 
        "destination" => v["run"]["destination_name"], 
        "departing_in" => TimeDifference.between(Time.now, Time.parse(v["time_timetable_utc"]).localtime).in_minutes.to_i.to_s + " minutes" 
      } 
    }
  end

end
