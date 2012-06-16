class Newsitem
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at

  has_and_belongs_to_many :places
  has_and_belongs_to_many :networks
  belongs_to :source

  field :title, :type => String
  field :url, :type => String

end
