class Network
  include Mongoid::Document
  include Mongoid::Slug

  has_many :groups

  field :name, :type => String
  slug :name, reserve: ['admin', 'root']

  def to_name
    name.downcase.gsub('-', ' ')
  end
end