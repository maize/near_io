class FacebookPlace
  include Mongoid::Document
  include Mongoid::FullTextSearch
  # include Mongoid::Slug
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at

  has_and_belongs_to_many :followers, class_name: "User", inverse_of: nil

  # before_save :update_index
  before_destroy :remove_from_index

  field :name, :type => String
  field :facebook_id, :type => Integer
  field :location, :type => Hash

  paginates_per 25

  fulltext_search_in :name, :index_name => 'mongoid_fulltext.name'

  def self.find_by_facebook_id(fb_id) 
    where(:facebook_id => fb_id).first
  end

  def self.find_all_by_name(name) 
    where(:name => name.gsub("-"," "))
  end

  # Mongoid does not have the dynamic finders that active record does
  def self.find_by_name(name) 
    where(:name => name.gsub("-"," ")).first
  end

  def update_index
    FacebookPlace.update_ngram_index
  end

  def remove_from_index
    FacebookPlace.remove_from_ngram_index
  end

  def self.search_by_name(name)
    update_index
    fulltext_search(name, :index => 'mongoid_fulltext.name')
  end

  def latitidude
  	return self.location["latitude"]
  end

  def longitude
  	return self.location["longitude"]
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  def followBy(user)
    self.followers.push(user)
    self.save
  end

  def unfollowBy(user)
    self.followers.delete(user)
    self.save
  end

  def isFollowedBy(user)
    if self.followers.exists? && self.followers.find(user.id)
      true
    else
      false
    end
  end
end
