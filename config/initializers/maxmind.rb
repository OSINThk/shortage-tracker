require 'maxmind/db'
require 'geo_ip'

$geoip_city = GeoIp.new('City')
$geoip_asn = GeoIp.new('ASN')
