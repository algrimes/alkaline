class PTVApi
  
  require 'open-uri'
  require 'openssl'
  require 'json'
  
  attr_reader :dev_id, :key
  
  def initialize dev_id, key
    @dev_id = dev_id
    @key = key
  end
  
  def healthcheck
    send_request "/v2/healthcheck"
  end 
  
  def stops_near_me location
    response = send_request "/v2/nearme/latitude/#{location.lat}/longitude/#{location.long}"
    response.map { |result| Model::Stop.new(result["result"]) }
  end
  
  def broad_next_departures stop, number_of_results
    send_request "/v2/mode/#{stop.transport_type.id}/stop/#{stop.stop_id}/departures/by-destination/limit/#{number_of_results}"
  end
  
  private 
  
  attr_writer :dev_id, :key
  
  def send_request path
    uri = URI::HTTP.build({ 
      :scheme => "http", 
      :host => "timetableapi.ptv.vic.gov.au", 
      :path => path, 
      :query => "devid=#{@dev_id}"})
      
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, @key, uri.path + "?" + uri.query)
    uri.query = uri.query + "&signature=#{signature}"
    JSON.parse(open(uri).read)
  end
  
end