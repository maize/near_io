class Tweet
  include Mongoid::Document
  field :twitter_id, :type => Integer
  field :handle, :type => String
  field :text, :type => String
  field :location, :type => Hash
end