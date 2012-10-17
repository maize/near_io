class Network
    include Mongoid::Document
    include Mongoid::Slug

    has_and_belongs_to_many :groups

    field :name, :type => String
    field :location, :type => Array
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