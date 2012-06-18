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

    render
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

      # p "Start crawling.."
      # @sites_list = ["www.ucl.ac.uk"]
      # @crawler = Apis::Crawler.new.spider_sitelist(@sites_list,@place.name)
    rescue
      puts "Error #{$!}"
    end

    # Get Tweets relevant to location
    unless @place.twitter.nil?
      p "Searching for tweets by handle.."
      search_tweets = "to "+@place.twitter
    else
      p "Searching for tweets by name.."
      search_tweets = @place.name+""
    end

    @tweets = Twitter.search(search_tweets, :lang => "en", :gecode => @place.lat.to_s+","+@place.lon.to_s+",1mi", :result_type => "recent")
    @news_items = []

    @tweets.each do |tweet|
      news_item = NewsItem.new
      news_item.tweet_id = news_item.id
      news_item.author = tweet.from_user
      news_item.content = tweet.text
      news_item.source = tweet.source

      # Check if tweet exists already in db
      # if NewsItem.where(:twitter_id => news_item.tweet_id).nil?
        news_item.save
      # end
      @news_items.push(news_item)
    end

    @articles = NewsItem.where(:type => "blog")

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
