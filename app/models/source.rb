class Source
	include Mongoid::Document

	has_many :newsitems

	field :title, :type => String
	field :baseurl, :type => String
end

class Blog < Source

end

class NewsSite < Source

end