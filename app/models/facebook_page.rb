class FacebookPage
  include Mongoid::Document

  has_and_belongs_to_many :facebook_events, inverse_of: nil, autosave: true
  belongs_to :group

  field :facebook_id, :type => Integer
  field :name, :type => String
  field :is_published, :type => Boolean
  field :website, :type => String
  field :username, :type => String
  field :description, :type => String
  field :about, :type => String
  field :can_post, :type => Boolean
  field :talking_about_count, :type => Integer
  field :category, :type => String
  field :link, :type => String
  field :likes, :type => Integer

  def self.find_by_facebook_id(facebook_id)
    @graph = Koala::Facebook::API.new
    
    p "Get Facebook page by: "+facebook_id.to_s
    @result = @graph.get_object(facebook_id.to_s)
    @page = FacebookPage.get_by_hash(@result)
    @page
  end

  def get_facebook_events(access_token)
    #unless self.facebook_events.exists?
      fb_events = FacebookEvent.get_all_by_facebook_id(self.facebook_id, access_token)
      fb_events.each do |event|
        self.facebook_events.push(event)
      end
      self.save
    #end
    self.facebook_events
  end

  def self.get_by_hash(hash)
    @event = FacebookPage.new(
      :facebook_id  => hash["id"],
      :name         => hash["name"],
      :is_published => hash["is_published"],
      :website => hash["website"],
      :username => hash["username"],
      :description => hash["description"],
      :about => hash["about"],
      :can_post => hash["can_post"],
      :talking_about_count => hash["talking_about_count"],
      :category => hash["category"],
      :link => hash["link"],
      :likes => hash["likes"])

    @find_page = FacebookPage.where(:facebook_id => @event.facebook_id).first
    
    unless @find_page.nil?
      p "Found Facebook page in database.."
      @event = @find_page
    end

    @event
  end
end
