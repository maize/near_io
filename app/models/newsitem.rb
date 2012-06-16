class Newsitem
  include Mongoid::Document

  field :name, :type => String
  field :source, :type => String
  field :contents, :type => String

end
