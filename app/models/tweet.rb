class Tweet
  include Mongoid::Document
  field :twitter_id, :type => Integer
  field :handle, :type => String
  field :handle_id, :type => Integer
  field :text, :type => String
  field :location, :type => Hash
end