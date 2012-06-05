class Note
  include Mongoid::Document
  has_and_belongs_to_many :places
  has_and_belongs_to_many :networks

  field :name, :type => String
  field :message, :type => String
end
