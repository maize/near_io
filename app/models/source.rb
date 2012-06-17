class Source
  include Mongoid::Document

  has_many :newsitems

	field :title, :type => String :unique => true
	field :baseurl :type => String
end
