class FacebookGroup < FacebookModel
  include Mongoid::Document

  embedded_in :group

  validates_presence_of :privacy

  field :facebook_id, :type => Integer
  field :name, :type => String
  field :description, :type => String
  field :privacy, :type => String
  field :icon, :type => String
  field :updated_time, :type => Date
  field :email, :type => String

  def self.find_by_facebook_id(facebook_id)
    @graph = Koala::Facebook::API.new
    
    p "Get Facebook group by: "+facebook_id.to_s
    begin
      @result = @graph.get_object(facebook_id.to_s)
      @group = FacebookGroup.get_by_hash(@result)
    rescue Exception => exc
      p "Error:"+exc.message.to_s
    end
    
    @group
  end

  def self.get_by_hash(hash)
    @group = FacebookGroup.new(
      :facebook_id  => hash["id"],
      :name         => hash["name"],
      :description     => hash["description"],
      :privacy     => hash["privacy"],
      :icon     => hash["icon"],
      :email => hash["email"],
      :updated_time => hash["updated_time"])
    @group
  end
end