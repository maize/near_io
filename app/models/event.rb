class Event
  include Mongoid::Document
  include Mongoid::Spacial::Document

  has_one :facebook_event
  has_one :eventbrite_event
  has_one :meetup_event

  field :name, :type => String
  field :external_id, :type => String
  field :provider, :type => String
  field :start_time, :type => DateTime
  field :end_time, :type => DateTime
  field :location, :type => Array, :spacial => true

  spacial_index :source
end