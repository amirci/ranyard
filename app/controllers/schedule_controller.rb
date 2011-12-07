class ScheduleController < ApplicationController
  before_filter :authenticate_user!, :only => :edit
  before_filter :load_schedule, :except => :days
  
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { schedule: events_grouped_by_day }, :except => exceptions }
      format.js   { render json: { schedule: events_grouped_by_day }, :except => exceptions, :callback => params[:callback] }
    end
  end

  def edit
  end
  
  def days
    events = events_at(active_conference.days[params[:id].to_i - 1])
    respond_to do |format|
      format.json { render json: { day: events }, :except => exceptions }
      format.js   { render json: { day: events }, :except => exceptions, :callback => params[:callback] }
    end
  end
  
  private
    def exceptions
      ['created_at', 'updated_at', 'room_id', 'conference_id']
    end

    def events_at(date, events = active_conference.events)
      events.
        select(&events_starting_on_date(date)).
        map(&additional_attributes)
    end
    
    def events_grouped_by_day
      i = 1
      active_conference.
          days.
          inject({}) { |hash, date| hash["day_#{i}"] = events_at(date); i += 1; hash }
    end
        
    def additional_attributes
      ->(e) do
        room = e.room ? e.room.name : nil
        session_id = e.session ? e.session.id : nil
        e.attributes.merge(session_id: session_id, room: room)
      end
    end
    
    def events_starting_on_date(date)
      ->(e) { e.start.to_date == date }
    end

    def load_schedule
      @rooms = active_conference.rooms
      @events = active_conference.events
      @events_by_day = active_conference.
              days.
              inject({}) { |hash, date| hash[date] = @events.select(&events_starting_on_date(date)) ; hash }
    end
end
