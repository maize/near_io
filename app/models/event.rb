class Event
  include Mongoid::Document

  has_one :facebook_event
  has_one :eventbrite_event
  has_one :meetup_event

  field :provider, :type => String
end
