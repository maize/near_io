class Network
    include Mongoid::Document
    include Mongoid::Slug
    include Mongoid::Spacial::Document

    has_and_belongs_to_many :groups

    field :name, :type => String
    field :location, :type => Array, :spacial => true
    slug :name, reserve: ['admin', 'root']

    # spacial_index :location

    def to_name
        name.downcase.gsub('-', ' ')
    end

    def lat
        unless location.nil?
           location[:lat]
        end
    end

    def lng
        unless location.nil?
           location[:lng]
        end
    end
end