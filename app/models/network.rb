class Network
    include Mongoid::Document
    include Mongoid::Slug
    include Mongoid::Spacial::Document

    has_and_belongs_to_many :groups, inverse_of: nil, autosave: true

    field :name, :type => String
    field :location, :type => Array, :spacial => true
    slug :name, reserve: ['admin', 'root']

    def to_name
        name.downcase.gsub('-', ' ')
    end

    def latitude
        unless location.nil?
           location[:lat]
        end
    end

    def longitude
        unless location.nil?
           location[:lng]
        end
    end
end