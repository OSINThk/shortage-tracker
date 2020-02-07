require 'maxmind/db'
require 'lazy_geo_ip'

$geoip_city = LazyGeoIp.new('City')
$geoip_asn = LazyGeoIp.new('ASN')
