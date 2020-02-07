class LazyGeoIp
  def initialize(type)
    @current = nil
    @type = type
  end

  def get(*args)
    if @current.nil?
      setup()
    end

    @current.get(*args)
  end

  def setup
    @current = MaxMind::DB.new("GeoLite2-#{@type}.mmdb", mode: MaxMind::DB::MODE_MEMORY)
  end
end
