class MeetupEvent
  include Mongoid::Document
  field :name, :type => String
  field :meetup_id, :type => Integer
end
