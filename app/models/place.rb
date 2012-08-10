class Place
  include Mongoid::Document
  include Mongoid::FullTextSearch
  # include Mongoid::Slug
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at

  # before_save :update_index
  before_destroy :remove_from_index

  field :name, :type => String
  field :twitter, :type => String
  field :featured, :type => Boolean
  field :type

  # slug :id

  # def to_name
  #   name.downcase.gsub('-', ' ')
  # end
end
