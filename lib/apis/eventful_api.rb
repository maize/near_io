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

  def self.method_missing(method_id, *args)
    if match = /get_events_([_a-zA-Z]\w*)/.match(method_id.to_s)
      attribute_names = match.captures.last.split('_and_')
 
      request = ""
      attribute_names.each_with_index { |name, idx| request = request + name + "=" + args[idx] + (attribute_names.length-1 == idx ? "" : "&") }
 
      get_products(request)
    else
      super
    end
  end
end