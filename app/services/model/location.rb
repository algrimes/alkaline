class Model::Location
  
  attr_reader :lat, :long
  
  def initialize(lat, long)
    @lat = lat
    @long = long
  end
  
end