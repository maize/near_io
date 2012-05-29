class ApiController < ApplicationController
  def get_notes_by_longitude_latitude
  end

  def get_notes_by_note_name
  	@entities = Note.find :all, :conditions => ["name = ?", params[:note_name]]
    respond_to do |format|
      format.xml  { render :xml => @entities }
      format.json { render :json => @entities }
      format.js { render_json_with_callback @entities.to_json }
    end
  end

  def add_notes_by_text
  end
end
