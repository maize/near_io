class Network
    include Mongoid::Document
    include Mongoid::Slug
    include Mongoid::Spacial::Document

    has_and_belongs_to_many :groups

    field :name, :type => String
    field :location, :type => Array, :spacial => true
    slug :name, reserve: ['admin', 'root']

    def to_name
        name.downcase.gsub('-', ' ')
    end
end