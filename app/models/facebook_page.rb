class FacebookPage
  include Mongoid::Document

  belongs_to :group, autosave: true

  field :name, :type => String
  field :facebook_id, :type => Integer

  def find_by_facebook_id(facebook_id)
    graph = Koala::Facebook::API.new
    
    p "Get Facebook page by: "+facebook_id
    result = graph.get_object(facebook_id)
    p result
  end
end
