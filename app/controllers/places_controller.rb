class PlacesController < ApplicationController
  def index
    @places = Place.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @places }
    end
  end

  def search
    @places = FacebookPlace.find_by_name(current_user, params[:place][:name])
    @place = Place.new

    if @places.nil?
      flash[:notice] = "Nothing found!"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @places }
    end
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
    @events = FacebookEvent

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
