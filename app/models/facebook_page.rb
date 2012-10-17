class FacebookPage < FacebookModel
  include Mongoid::Document

  embedded_in :group, :polymorphic => true

  validates_presence_of :likes

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

  def self.get_by_hash(hash)
    @page = FacebookPage.new(
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

    @page
  end
end
