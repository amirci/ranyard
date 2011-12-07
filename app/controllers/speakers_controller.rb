class SpeakersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /speakers
  # GET /speakers.json
  def index
    @speakers = active_conference.speakers.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { speakers: json_attr(@speakers) }, :except => exceptions }
      format.js   { render json: { speakers: json_attr(@speakers) }, :except => exceptions, :callback => params[:callback] }
    end
  end

  # GET /speakers/1
  # GET /speakers/1.json
  def show
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {speaker: json_attr(@speaker).first }, :except => exceptions }
      format.js   { render json: {speaker: json_attr(@speaker).first }, :except => exceptions, :callback => params[:callback] }
    end
  end

  # GET /speakers/new
  # GET /speakers/new.json
  def new
    @speaker = active_conference.speakers.build

    respond_to do |format|
      format.html { render layout: 'admin' }
      format.json { render json: @speaker }
    end
  end

  # GET /speakers/1/edit
  def edit
    @speaker = Speaker.find(params[:id])
    render layout: 'admin'
  end

  # POST /speakers
  # POST /speakers.json
  def create
    @speaker = Speaker.new(params[:speaker])
    @speaker.conference = active_conference

    respond_to do |format|
      if @speaker.save
        format.html { redirect_to @speaker, notice: 'Speaker was successfully created.' }
        format.json { render json: @speaker, status: :created, location: @speaker }
      else
        format.html { render action: "new" }
        format.json { render json: @speaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /speakers/1
  # PUT /speakers/1.json
  def update
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      if @speaker.update_attributes(params[:speaker])
        format.html { redirect_to @speaker, notice: 'Speaker was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @speaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speakers/1
  # DELETE /speakers/1.json
  def destroy
    @speaker = Speaker.find(params[:id])
    @speaker.destroy

    respond_to do |format|
      format.html { redirect_to speakers_url }
      format.json { head :ok }
    end
  end
  
  private
    def exceptions
      ['created_at', 'updated_at', 'conference_id']
    end
    
    def json_attr(speakers)
       ([] << speakers).flatten.collect do |s| 
        attrib = s.attributes
        names = attrib.delete('name').split(' ')
        first_name = names.shift
        attrib.merge(first_name: first_name, last_name: names.join(' '))
      end
    end
end
