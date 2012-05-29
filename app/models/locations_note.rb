class LocationsNote < ActiveRecord::Base
  attr_accessible :location_id, :note_id
  belongs_to :location
  belongs_to :note
end
