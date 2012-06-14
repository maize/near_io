class PlacesController < ApplicationController
  def index
    @places = Place.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @places }
    end
  end

  def search    
    if params.has_key?(:place)
      search_name = params[:place][:name]
      @places = Place.search_by_name(search_name)
      if @places.nil?
        @places = Place.new
      end
    else
      @places = Place.new
    end

    if @places.nil?
      flash[:notice] = "Nothing found!"
    end

    render
  end

  def edit
    @place = Place.find_by_slug(params[:id])
  end

  def update
    @place = Place.find_by_slug(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to @place, :notice => 'Place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @place = Place.find_by_slug(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end

  def show
    @place = Place.find_by_slug(params[:id])

    if @place.nil?
      begin
        puts "Getting place by Foursquare.."
        @fsq_venue = NnApi::FourSquareApi.new.get_venue_by_id(params[:id])
        @place = Place.add_by_foursquare(@fsq_venue)
      rescue
        puts "Error #{$!}"
      end
    end

    begin
      @photos = NnApi::InstagramApi.new.get_media_nearby(@place.lat,@place.lon)
      @photos.data.each do |photo|
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
    rescue
      puts "Error #{$!}"
    end

    begin
      @place.save
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @place }
        format.xml { render :xml => @place }
      end
    rescue
      puts "Error #{$!}"
    end
  end
end
