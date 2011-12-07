class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_event, only: [:edit, :show, :update, :destroy]
  layout "admin"
  
  def index
    @events = active_conference.events.order(:start)
  end
  
  def edit
    find_sessions
  end
  
  def show
  end
  
  def new
    start = params[:date] || active_conference.start
    @event = Event.new(start: start, finish: start)
    find_sessions
  end
  
  def update
    if @event.update_attributes(params[:event])
      update_session
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @event.destroy
    redirect_to events_path
  end
  
  def create
    @event = active_conference.events.create(params[:event])
    update_session
    redirect_to @event, notice: 'Event was successfully created.'
  end

  private
    def find_event
      @event = Event.find(params[:id])
    end

    def find_sessions
      @sessions = active_conference.sessions.order(:title)
    end
    
    def update_session
      session_id = params[:session][:id] rescue ''
      @event.session = Session.find(session_id) unless session_id == ''
    end
end
