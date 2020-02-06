require 'maxmind/db'

$geoip_city = MaxMind::DB.new('GeoLite2-City.mmdb', mode: MaxMind::DB::MODE_MEMORY)
$geoip_asn = MaxMind::DB.new('GeoLite2-ASN.mmdb', mode: MaxMind::DB::MODE_MEMORY)
