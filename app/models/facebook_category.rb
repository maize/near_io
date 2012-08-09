class FacebookCategory
  include Mongoid::Document

  has_many :facebook_likes

  field :name, :type => String
end
