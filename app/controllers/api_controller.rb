require "json"

class ApiController < ApplicationController
  def get_notes_by_longitude_latitude
  end

  def get_notes_by_note_name
  	@entities = Note.find :all, :conditions => ["name = ?", params[:note_name]]
    respond_to do |format|
      format.xml  { render :xml => @entities }
      format.json { render :json => @entities }
    end
  end

  def get_locations_nearby
    @venues = NnApi::FourSquareApi.new.get_nearby_venues(params[:lat],params[:lon])
    @places = []
    @venues.each do |venue|
      @place = Place.add_by_foursquare(venue)
      @places.push(@place)
    end
    respond_to do |format|
      format.xml  { render :xml => @places }
      format.json { render :json => @places }
    end
  end

  def get_media_nearby
    @media = NnApi::InstagramApi.new.get_media_nearby(params[:lat],params[:lon],params[:distance])
    respond_to do |format|
      format.xml  { render :xml => @media }
      format.json { render :json => @media }
    end
  end

  def add_notes_by_text
  end

  def add_note
    @note = Note.create(:name => params[:note_name])
    respond_to do |format|
      format.xml  { render :xml => @note }
      format.json { render :json => @note }
    end
  end
end