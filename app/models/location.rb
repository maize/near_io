class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name
  has_many :locations_notes
  has_many :notes, :through => :locations_notes
end
