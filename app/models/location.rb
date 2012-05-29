class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name
  has_many :allocations
  has_many :notes, :through => :allocations
end
