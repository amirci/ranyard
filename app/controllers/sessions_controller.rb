class SessionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :attending, :not_attending]

  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = active_conference.sessions.order('title')
    @tags = @sessions.tag_counts_on(:tags)
    
    sessions = @sessions.collect { |s| project_one_session(s) }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { sessions: sessions }, :except => exceptions }
      format.js   { render json: { sessions: sessions }, :except => exceptions, :callback => params[:callback] }
    end
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
    @session = Session.find(params[:id])
    session = project_one_session(@session)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { session: session }, :except => exceptions }
      format.js   { render json: { session: session }, :except => exceptions, :callback => params[:callback] }
    end
  end

  # GET /sessions/new
  # GET /sessions/new.json
  def new
    @session = Session.new
    @speakers = active_conference.speakers
    
    respond_to do |format|
      format.html { render layout: 'admin' }
      format.json { render json: @session  }
    end
  end

  # GET /sessions/1/edit
  def edit
    @session = Session.find(params[:id])
    @speakers = active_conference.speakers
    render layout: 'admin'
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = Session.new(params[:session].merge(conference: active_conference))

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully created.' }
        format.json { render json: @session, status: :created, location: @session }
      else
        format.html { render action: "new" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sessions/1
  # PUT /sessions/1.json
  def update
    @session = Session.find(params[:id])

    respond_to do |format|
      if @session.update_attributes(params[:session])
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session = Session.find(params[:id])
    @session.destroy

    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json { head :ok }
    end
  end

  def attending
    session = Session.find(params[:id])
    session.planning_to_attend += 1 
    session.save!

    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json { render :json => { :id => params[:id].to_i } }
      format.js   { render :json => { :id => params[:id].to_i }, :callback => params[:callback] }
    end
  end
  
  def not_attending
    session = Session.find(params[:id])
    session.planning_to_attend -= 1 
    session.save!

    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json { render :json => { :id => params[:id].to_i } }
      format.js   { render :json => { :id => params[:id].to_i }, :callback => params[:callback] }
    end
  end

  def attendance
    @sessions = active_conference.sessions.order('planning_to_attend DESC')
  end
  
  private
    def project_one_session(s)
      s.attributes.merge(
        speakers: s.speakers.collect(&:id), 
        tags: s.tag_list.sort_by(&:upcase),
        start: s.event.nil? ? nil : s.event.start,
        finish: s.event.nil? ? nil : s.event.finish,
        room: s.event.nil? ? nil : s.event.room.name
      ) 
    end
    
    def exceptions
      [ 'created_at', 'updated_at', 
        'event_id', 'upvotes', 'downvotes', 
        'planning_to_attend',
        'conference_id']
    end
  
end
