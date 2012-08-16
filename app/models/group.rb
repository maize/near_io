class Group
  include Mongoid::Document

  has_one :facebook_group, autosave: true
  has_one :facebook_page, autosave: true

  belongs_to :network

  field :name, :type => String
end
