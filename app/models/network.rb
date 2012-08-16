class Network
  include Mongoid::Document

  has_many :groups

  field :name, :type => String
end
