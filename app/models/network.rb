class Network
    include Mongoid::Document
    include Mongoid::Slug

    has_and_belongs_to_many :groups

    field :name, :type => String
    field :latitude, :type => String
    field :longitude, :type => String

    slug :name, reserve: ['admin', 'root']
end