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
    @venues = NnApi::FourSquareApi.new.get_nearby_venues
    @venues.each do |venue|
      p venue.json
    end
    #render :json => @venues
  end

  def get_media_nearby
    @media = NnApi::InstagramApi.new.get_media_nearby
    p @media
    #render :json => @media
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