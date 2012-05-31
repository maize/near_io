class Location
  include Mongoid::Document
  has_and_belongs_to_many :notes

  field :name, :type => String
  field :latlon, :type => Array
end
