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

    @featured_places = Place.where(:featured => true)

    @search_place = Place.new

    render
  end

  def follow
    @fb_id = params[:id].to_s
    @place = FacebookPlace.find(@fb_id)
    @place.followBy(current_user)
    redirect_to root_url
  end

  def unfollow
    @place = FacebookPlace.find(params[:id])
    @place.unfollowBy(current_user)
    redirect_to root_url
  end

  def edit
    @place = Place.find_by_slug(params[:id])
  end

  def update
    @place = Place.find_by_slug(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { render :action => "edit", :notice => 'Place was successfully updated.' }
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
    @place = FacebookPlace.find(params[:id])
    @tweets = TwitterScraper.new.track_keywords_nearby(@place.longitude, @place.latitude)

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
