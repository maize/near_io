class Photo
  include Mongoid::Document

  embedded_in :place

  field :instagram_id, :type => String
  field :name, :type => String
  field :low_resolution, :type => String
  field :thumbnail, :type => String
  field :standard_resolution, :type => String
end
