class Event
  include Mongoid::Document

  field :external_id, :type => String
  field :provider, :type => String
end
