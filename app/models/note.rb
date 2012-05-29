class Note < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :locations_notes
  has_many :locations, :through => :locations_notes
end
