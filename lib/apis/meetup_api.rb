require 'rubygems'
require 'httparty'
 
class Apis::MeetupApi
  include HTTParty
  base_uri 'api.meetup.com/2'
  default_params :key => '165b4e44292b1a1f7a2ee432662c'
  format :json

  def self.get_open_events_nearby(lat, lon, radius)
    get("/open_events?lat='#{lat}'&lon='#{lon}'&radius=#{radius}")
  end

  def self.get_group_by_name(name)
    get("/groups?group_urlname='#{name}'")
  end

  def self.get_events_by_group_id(id)
    get("/events?group_id='#{id}'")
  end
end