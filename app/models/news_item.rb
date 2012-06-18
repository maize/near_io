class NewsItem
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at

  has_and_belongs_to_many :places
  has_and_belongs_to_many :networks
  has_many :bids, class_name: 'Bid', inverse_of: :news_item

  field :tweet_id, :type => Integer
  field :name, :type => String
  field :author, :type => String
  field :content, :type => String
  field :url, :type => String
  field :source, :type => String
end
