class ConferencesController < ApplicationController
  before_filter :authenticate_user!, except: [:last_update]
  layout 'admin'
  
  def index
    @conferences = Conference.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferences }
    end
  end

  def show
    @conference = Conference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /admin/conferences/new
  # GET /admin/conferences/new.json
  def new
    @conference = Conference.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference }
    end
  end

  def edit
    @conference = Conference.find(params[:id])
  end

  def create
    @conference = Conference.new(params[:conference])

    respond_to do |format|
      if @conference.save
        format.html { redirect_to @conference, notice: 'Conference was successfully created.' }
        format.json { render json: @conference, status: :created, location: @conference }
      else
        format.html { render action: "new" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/conferences/1
  # PUT /admin/conferences/1.json
  def update
    @conference = Conference.find(params[:id])

    Rails.logger.debug { params[:conference] }
    
    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        format.html { redirect_to @conference, notice: 'Conference was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/conferences/1
  # DELETE /admin/conferences/1.json
  def destroy
    @conference = Conference.find(params[:id])
    @conference.destroy

    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :ok }
    end
  end
  
  def last_update
    json = { last_update: ConferenceStatus.last_update }.to_json
    respond_to do |format|
      format.json { render json: json }
      format.js   { render json: json, :callback => params[:callback] }
    end
  end
  
end
