class Model::Stop
  
  attr_reader :suburb, :transport_type, :location_name, :lat, :long, :stop_id
  
  def initialize(args)
    @transport_type = "Model::TransportType::#{args.delete("transport_type").titleize}".constantize
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
  
end