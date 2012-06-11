class Place
  include Mongoid::Document

  has_and_belongs_to_many :notes

  embeds_many :photos

  field :name, :type => String
  field :foursquare_id, :type => String
  field :latlon, :type => Array
  field :city, :type => String
  field :address, :type => String
  field :country, :type => String
  field :postal_code, :type => String
  field :state, :type => String
  field :contact, :type => Hash

  def to_param
    name.gsub(' ', '-')
  end

  def to_name
    name.downcase.gsub('-', ' ')
  end

  # Mongoid does not have the dynamic finders that active record does
  def self.find_by_name(name) 
    where(:name => name).first 
  end

  def lat
  	return self.latlon[0]
  end

  def lon
  	return self.latlon[1]
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  def Place.add_by_foursquare(fsq_venue)
  	@p = Place.new	
    @p.name = fsq_venue.name
    @p.foursquare_id = fsq_venue.id
    @p.latlon = [fsq_venue.location.lat,fsq_venue.location.lng]
    @p.city = fsq_venue.location.city
    @p.address = fsq_venue.location.address
    @p.country = fsq_venue.location.country
    @p.postal_code = fsq_venue.location.postal_code
    @p.state = fsq_venue.location.state
    
    unless fsq_venue.contact.nil?
      @p.contact = fsq_venue.contact
    end

    @p.save

    return @p
  end
end
