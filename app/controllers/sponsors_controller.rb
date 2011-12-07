class SponsorsController < ApplicationController

  def index
    sponsors = active_conference.sponsors

    respond_to do |format|
      format.json { render json: { sponsors: sponsors }, :except => exceptions }
      format.js   { render json: { sponsors: sponsors }, :except => exceptions, :callback => params[:callback] }
    end
  end
  
  private
    def exceptions
      ['created_at', 'updated_at', 'conference_id']
    end
  
end
