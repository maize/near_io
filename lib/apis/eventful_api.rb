require 'rubygems'
require 'httparty'
 
class Apis::EventfulApi
  include HTTParty
  base_uri 'api.eventful.com/rest'
  default_params :app_key => 'gvSfgR2r8XVszHxw'
  format :xml
 
  # Search
  def self.get_events_by_location_name(location)
    get("/events/search?location=#{location}")
  end

  def self.get_events_nearby(lat, lon, radius)
    get("/events/search?location='#{lat},#{lon}'&within=#{radius}")
  end
end