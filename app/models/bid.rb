class Bid
  include Mongoid::Document

  belongs_to :news_item, class_name: 'NewsItem', inverse_of: :bids

  field :price, :type => Integer

  validates :price, :numericality => true
end
