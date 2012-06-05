class PlacesController < ApplicationController
  # GET /places
  # GET /places.json
  def index
    @places = place.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @places }
    end
  end

  # GET /places/1
  # GET /places/1.json
  def show
    begin
      @place = Place.find(params[:id])
    rescue
      @fsq_venue = NnApi::FourSquareApi.new.get_venue_by_id(params[:id])
      @place = Place.add_by_foursquare(@fsq_venue)
    end

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

    @place.save

    # @place.photos = @photos.data

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @place }
      format.xml { render :xml => @place }
    end
  end

  # GET /places/new
  # GET /places/new.json
  def new
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, :notice => 'place was successfully created.' }
        format.json { render :json => @place, :status => :created, :place => @place }
      else
        format.html { render :action => "new" }
        format.json { render :json => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.json
  def update
    @place = place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to @place, :notice => 'place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place = place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end
end
