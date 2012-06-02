class NnApi::FourSquareApi
	attr_accessor :foursquare

	def initialize
		@foursquare ||= Foursquare::Base.new("LTLT33VNMUM3C0ZVV1ESWABF1JCUJBB0PXDUTFB4N4VQTS5S", "ZQNUJKWDTOGLPB01M2CZWO4I5PNFACHPA2KKG2B2G1AVO3R3")
	end

	def get_nearby_venues
	    return @foursquare.venues.nearby(:ll => "51.5248,-0.133427")
	end
end