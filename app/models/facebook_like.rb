class FacebookLike
  include Mongoid::Document

  belongs_to :facebook_category, autosave: true

  field :facebook_id, :type => Integer
  field :name, :type => String
  field :facebook_created_time, :type => Date
end
