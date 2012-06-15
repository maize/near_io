require "geocoder"

class Apis::FoursquareApi
	attr_accessor :foursquare

	def initialize
		@foursquare ||= Foursquare::Base.new("LTLT33VNMUM3C0ZVV1ESWABF1JCUJBB0PXDUTFB4N4VQTS5S", "ZQNUJKWDTOGLPB01M2CZWO4I5PNFACHPA2KKG2B2G1AVO3R3")
	end

	Foursquare.verbose = true
	def Foursquare.log(message)
	  Rails.logger.info("[foursquare] #{message}") # HAX, SORRY BRANDON
	end

	def get_nearby_venues(lat,lon)
	    return @foursquare.venues.nearby(:ll => lat+","+lon)
	end

	def get_venue_by_id(venue_id)
		return foursquare.venues.find(venue_id)
	end

	def get_venue_by_name(venue_name,ll)
		return foursquare.venues.search(:query => venue_name, :ll => ll)
	end
end