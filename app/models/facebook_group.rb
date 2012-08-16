class FacebookGroup
  include Mongoid::Document

  belongs_to :group, autosave: true

  field :name, :type => String
  field :facebook_id, :type => Integer
  field :description, :type => Boolean
  field :privacy, :type => String
  field :icon, :type => String
  field :updated_time, :type => Date
  field :email, :type => String

  def find_by_facebook_id(facebook_id)
    graph = Koala::Facebook::API.new
    
    p "Get Facebook group by: "+facebook_id
    result = graph.get_object(facebook_id)
    p result
  end
end
