require 'forwardable'
# Objects that we need
# 1. bus
# 2. destinations
# 3. route
# 4. solver
#
class SortedArray < Array
  # sort_by: a block that define what attribute do
  # you want to stort by
  def initialize(*args, &sort_by)
    @sort_by = sort_by
    super(*args)
    sort! &sort_by
  end

  def insert(i, v)
    insert_before = index(find {|x| @sort_by.call(x, v) == 1})
    super(insert_before ? insert_before : -1, v)
  end

  def <<(v)
    insert(0, v)
  end
end

class GeoLocation
  # Algorithm:
  # dlon = lon2 - lon1
  # dlat = lat2 - lat1
  # a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
  # c = 2 * atan2( sqrt(a), sqrt(1-a) )
  # d = R * c (where R is the radius of the Earth)
  class << self
    def haversine(distance1, distance2)
      radius_of_earth = 6378.14
      rlat1, rlong1, rlat2, rlong2 = [distance1.lat, distance1.long, distance2.lat, distance2.long].map { |d| as_radians(d)}
      dlon = rlong1 - rlong2
      dlat = rlat1 - rlat2

      a = power(Math.sin(dlat/2), 2) + Math.cos(rlat1) * Math.cos(rlat2) * power(Math.sin(dlon/2), 2)
      great_circle_distance = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      radius_of_earth * great_circle_distance
    end

    def as_radians(degrees)
      degrees * Math::PI/180
    end

    def power(num, pow)
      num ** pow
    end
  end
end

class Destination
  def initialize(loc)
    @lat  = loc[:lat]
    @long = loc[:long]
  end
end

class Destinations
  extend Forwardable
  def_delegator :@destinations, :size, :[]

  def initialize(destinations)
    @destinations = destinations
  end
end

module Route
end

class Bus
  include Route

  def initialize
  end
end

class Solver
  def initialize
    @bus = Bus.new
  end

  def create_locations_from_file(file)
    locations = []
    regx = /-*[0-9]+\.[0-9]+/
    File.open(file).map(&:strip).each do |address|
      location = address.scan(regx).map {|str| str.to_f}
      locations << Destination.new({:lat => location.first, :long => location.last})
    end
    Destinations.new(locations)
  end

  # Algorithm:
  # 1. Cache the distance from self to other destination
  # 2. to find the solution in shorest way:
  #    a. queue up all the closest destination
  #    b. use depth first search to try out all the
  #       closest destination untill it found the last
  #       destination
  def solve
    @destinations = create_locations_from_file(file)
    @destinations.build_distance_table
    @bus.set_start(@destinations.get_start)
    while @bus.has_next_destination do
      @bus.drive_to_next_closet_destination
    end
    @bus.route
  end

end
