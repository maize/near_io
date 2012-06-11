class PlacesController < ApplicationController
  def index
    @places = Place.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @places }
    end
  end

  def show
    @search_name = params[:id].gsub("-"," ");
    @place = Place.find_by_name(@search_name)

    if @place.nil?
      @fsq_venue = NnApi::FourSquareApi.new.get_venue_by_id(params[:id])
      @place = Place.add_by_foursquare(@fsq_venue)
    end

    @photos = NnApi::InstagramApi.new.get_media_nearby(@place.lat,@place.lon)
    @photos.data.each do |photo|
      p @photos
      @p = Photo.new
      unless photo.caption.nil?
        @p.instagram_id = photo.id
        @p.name = photo.caption.text
        @p.low_resolution = photo.images.low_resolution.url
        @p.standard_resolution = photo.images.standard_resolution.url
        @p.thumbnail = photo.images.thumbnail.url
      end
      @place.photos.push(@p)
    end

    @place.save

    # @place.photos = @photos.data

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @place }
      format.xml { render :xml => @place }
    end
  end
  
  def search
    @places = Place.find(:all, :conditions => ['name LIKE ? ', '%'+params[:name]+'%'])
  end
end
