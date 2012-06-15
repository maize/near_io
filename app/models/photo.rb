class Photo
  include Mongoid::Document

  field :instagram_id, :type => String
  field :name, :type => String
  field :low_resolution, :type => String
  field :thumbnail, :type => String
  field :standard_resolution, :type => String

  def self.find_by_instagram_id(instagram_id) 
    where(:instagram_id => instagram_id).first
  end

  def self.add_by_instagram(photo)
  	@p = Photo.find_by_instagram_id(photo.id.to_s)
  	if @p.nil?
	  	@p = Photo.new
		@p.instagram_id = photo.id
		unless photo.caption.nil?
			@p.name = photo.caption.text
		end
		@p.low_resolution = photo.images.low_resolution.url
		@p.standard_resolution = photo.images.standard_resolution.url
		@p.thumbnail = photo.images.thumbnail.url
		@p.save
  	end

    return @p
  end
end