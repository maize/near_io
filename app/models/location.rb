class Location
  include Mongoid::Document

  has_and_belongs_to_many :notes

  field :name, :type => String
  field :foursquare_id, :type => String
  field :latlon, :type => Array
  field :city, :type => String
  field :address, :type => String
  field :country, :type => String
  field :postal_code, :type => String
  field :state, :type => String
  field :twitter, :type => String

  def Location.add_by_foursquare(fsq_venue)
  	self = Location.new	
	@l.name = fsq_venue.name
	@l.foursquare_id = fsq_venue.id
	@l.latlon = [fsq_venue.location.lat,fsq_venue.location.lng]
	@l.city = fsq_venue.location.city
	@l.address = fsq_venue.location.address
	@l.country = fsq_venue.location.country
	@l.postal_code = fsq_venue.location.postal_code
	@l.state = fsq_venue.location.state
	@l.twitter = fsq_venue.contact.twitter.nil?
	@l.save
	return @l
  end
end
