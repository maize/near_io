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

      # Get lat lon by Geocoder
      if (request.location.latitude == 0 || request.location.longitude == 0)
        # Take randomg lat lon for development, e.g. London coordinates
        latlon = "51.5171,0.1062";
      else
        latlon = request.location.latitude.to_s+","+request.location.longitude.to_s
      end

      # Search for places on Foursquare
      @places = []
      @foursquare_places = Apis::FoursquareApi.new.get_venue_by_name(search_name, latlon)
      @foursquare_places["places"].each do |place|
        @place = Place.add_by_foursquare(place)
        @places.push(@place)
      end

      if @foursquare_places.nil? || @foursquare_places.size() == 0
        @places = Place.new
        p "Error getting Foursquare Places"  
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
        @fsq_venue = Apis::FoursquareApi.new.get_venue_by_id(params[:id])
        @place = Place.add_by_foursquare(@fsq_venue)
      rescue
        puts "Error #{$!}"
      end
    end

    # Get Instagram photos
    begin
      @photos = []
      @ext_photos = Apis::InstagramApi.new.get_media_nearby(@place.lat,@place.lon)
      @ext_photos.data.each do |photo|
        @p = Photo.add_by_instagram(photo)
        @place.photos.push(@p)
      end
      @place.save
    rescue
      puts "Error #{$!}"
    end

    # Get Tweets relevant to location
    @tweets = Twitter.search(@place.name, :gecode => @place.lat.to_s+","+@place.lon.to_s+",1mi", :result_type => "recent")

    begin
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
