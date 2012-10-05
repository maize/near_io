class FacebookGroup < FacebookModel
  include Mongoid::Document

  has_and_belongs_to_many :facebook_events, inverse_of: nil, autosave: true
  belongs_to :group

  field :facebook_id, :type => Integer
  field :name, :type => String
  field :description, :type => String
  field :privacy, :type => Boolean
  field :icon, :type => String
  field :updated_time, :type => Date
  field :email, :type => String

  def self.find_by_facebook_id(facebook_id)
    @graph = Koala::Facebook::API.new
    
    p "Get Facebook group by: "+facebook_id.to_s
    @result = @graph.get_object(facebook_id.to_s)
    @group = FacebookGroup.get_by_hash(@result)
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

    @find_group = FacebookGroup.where(:facebook_id => @group.facebook_id).first
    
    unless @find_group.nil?
      p "Found Facebook group in database.."
      @group = @find_group
    end

    @group
  end
end