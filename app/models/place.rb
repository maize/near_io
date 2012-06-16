class Place
  include Mongoid::Document
  include Mongoid::FullTextSearch
  include Mongoid::Slug
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at

  has_and_belongs_to_many :notes
  has_and_belongs_to_many :newsitems
  embeds_many :photos

  # before_save :update_index
  before_destroy :remove_from_index

  field :name, :type => String

  field :foursquare_id, :type => String
  field :latlon, :type => Array
  field :city, :type => String
  field :address, :type => String
  field :country, :type => String
  field :postal_code, :type => String
  field :state, :type => String
  field :twitter, :type => String
  field :contact, :type => Hash
  field :featured, :type => Boolean

  fulltext_search_in :name, :index_name => 'mongoid_fulltext.name'

  slug :name

  def to_name
    name.downcase.gsub('-', ' ')
  end

  def update_index
    Place.update_ngram_index
  end

  def remove_from_index
    Place.remove_from_ngram_index
  end

  def self.search_by_name(name)
    update_index
    fulltext_search(name, :index => 'mongoid_fulltext.name')
  end

  # Mongoid does not have the dynamic finders that active record does
  def self.find_by_name(name) 
    where(:name => name.gsub("-"," ")).first
  end

  def self.find_by_foursquare_id(fqs_id) 
    where(:foursquare_id => fqs_id).first
  end

  def self.find_all_by_name(name) 
    where(:name => name.gsub("-"," "))
  end

  def name=(name)
    write_attribute(:name,"#{name} - test")
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
    # Check if place already exists in db
  	@p = Place.find_by_foursquare_id(fsq_venue.id)

    if @p.nil?
      @p = Place.new
      @p.name = fsq_venue.name
      @p.foursquare_id = fsq_venue.id
      @p.latlon = [fsq_venue.location.lat,fsq_venue.location.lng]
      @p.city = fsq_venue.location.city
      @p.address = fsq_venue.location.address
      @p.country = fsq_venue.location.country
      @p.postal_code = fsq_venue.location.postal_code
      @p.state = fsq_venue.location.state
      
      # Check if there is more info like Twitter handle
      unless fsq_venue.contact.nil?
        @p.contact = fsq_venue.contact
        @p.twitter = fsq_venue.contact["twitter"]
      end

      @p.save
    end

    return @p
  end
end
