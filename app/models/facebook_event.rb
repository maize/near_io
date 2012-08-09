class FacebookEvent
  include Mongoid::Document
  field :facebook_id, :type => Integer
  field :name, :type => String
end
