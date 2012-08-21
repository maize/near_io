class EventbriteEvent
  include Mongoid::Document
  field :name, :type => String
  field :eventbrite_id, :type => Integer

  def get?
  end
end
