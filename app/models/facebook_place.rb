class FacebookPlace
  include Mongoid::Document

  field :facebook_id, :type => Integer
  field :name, :type => String
  field :location, :type => Hash
end
