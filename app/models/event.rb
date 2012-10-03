class Event
  include Mongoid::Document
  include Mongoid::Spacial::Document

  has_one :facebook_event
  has_one :eventbrite_event
  has_one :meetup_event

  field :external_id, :type => String
  field :provider, :type => String
  field :start_time, :type => DateTime
  field :end_time, :type => DateTime
  field :location, :type => Array, :spacial => true
  
  spacial_index :location

  paginates_per 25

  def name
    unless facebook_event.nil? and facebook_event.name.nil?
      facebook_event.name
    else
      "N/A"
    end
  end
end