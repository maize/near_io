require "instagram"

class Classes::InstagramApi
	include Instagram

	def initialize
		Instagram.configure do |config|
		  config.client_id = "f8c5b8d1064043fb8486cd18b9c2c238"
		  config.access_token = "cfe588db9f57411f95a13e615f602049"
		end
	end

	def get_media_nearby(lat,lon,distance = 100)
		return Instagram.media_search(lat,lon, { 
			:client_id => "f8c5b8d1064043fb8486cd18b9c2c238",
			:distance => distance })
	end
end