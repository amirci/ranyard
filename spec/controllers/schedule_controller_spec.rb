require 'spec_helper'

describe ScheduleController do
  include SignInSpecHelper
  
  let(:exceptions) { ['created_at', 'updated_at', 'room_id', 'conference_id'] }

  let(:conference) { stub_model(Conference, 
                                name: 'PrDC', 
                                start: 'Nov 21, 2011', 
                                finish: 'Nov 22, 2011',
                                active: true) }
  
  let(:rooms) { (1..1).collect { |i| stub_model(Room, name: "Room #{i}", id: i) } }
  
  let(:slots) do
    [conference.start.to_datetime.utc, conference.finish.to_datetime.utc].
      collect do |date|
        (1..1).collect { |i| TimeSlot.new(start: date.change(hour: 8 + i), 
                                          finish: date.change(hour: 8 + i + 1)) } 
      end.flatten                                      
  end

  # create events for each slot and room
  let(:events) do
    slots.map do |slot|
      i = 0
      rooms.map do |room| 
        i += 1
        stub_model(Event, 
                   room: room, 
                   start: slot.start, 
                   finish: slot.finish,
                   session: i % 3 == 0 ? nil : stub_model(Session, title: 'Session', abstract: 'Super session!')) 
      end
    end.flatten
  end
  

  
  before do
    subject.stub!(:active_conference).and_return(conference)
    conference.stub(:rooms).and_return(rooms)
    conference.stub(:events).and_return(events)    
  end

  describe "#show" do
    let(:events_map) do
      slots.inject({}) do |smap, slot|
        smap[slot] = events.select { |e| e.start == slot.start }.inject({}) do |rmap, e|
          rmap[e.room.name] = e
          rmap
        end
        smap
      end
    end
    
    let(:json) do
       { schedule: { day_1: json_attributes(events, conference.start), 
                     day_2: json_attributes(events, conference.finish) } }.to_json(except: exceptions) 
    end

    context "when format is html" do
       before { get :show }
       
       it { should respond_with_content_type(:html) }
       it { should assign_to(:rooms).with(rooms)    }
       it { should assign_to(:events) }
       it { should render_template(:show) }
    end

    context "when format is json" do
      before { get :show, :format => :json }
      
      it { should respond_with_content_type(:json) }
      it { should respond_with(:success) }
      it { response.body.should eq(json) }
    end

    context "when format is js" do
      before { get :show, :format => :js, :callback => :mycallback }
      
      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
      it { response.body.should eq("mycallback(#{json})") }
    end
  end

  describe "#edit" do
    
    let(:conference) { stub_model(Conference, active: true, start: 'Nov 21, 2011', finish: 'Nov 22, 2011') }

    let(:days) { [DateTime.parse('Nov 21, 2011'), DateTime.parse('Nov 22, 2011')] }

    context 'when not logged in' do
      before { get :edit }
      
      it { should respond_with(:redirect)    }
      it { should redirect_to(log_in_path)   }
    end
    
    context 'when admin' do
      before do 
        Conference.stub(:where).with(:active => true).and_return([conference])
        sign_in
        get :edit 
      end

      it { should respond_with_content_type(:html) }
      it { should render_template('edit')          }
      it { should assign_to(:rooms).with(rooms)    }
      it { should assign_to(:events) }
    end
    
    context 'when admin with no conferences' do
      before do 
        Conference.stub(:where).with(:active => true).and_return([])
        sign_in
        get :edit 
      end

      it { should respond_with_content_type(:html) }
      it { should render_template('edit')          }
      it { should assign_to(:rooms).with(rooms)    }
      it { should assign_to(:events) }
    end
  end
  
  describe "#days" do
    let(:events_on_date) { events.select { |e| e.start.to_date == conference.start } }
    let(:json) { { day: events_on_date.map { |e| complete_attributes(e) } }.to_json(except: exceptions) }

    before do
      Event.stub(:select).and_return(events_on_date)
    end
    
    
    context "when format is json" do
      before { get :days, :format => :json, :id => 1 }
      
      it { should respond_with_content_type(:json) }
      it { should respond_with(:success) }
      it { response.body.should eq(json) }
    end

    context "when format is js" do
      before { get :days, :format => :js, :id => 1, :callback => :mycallback }
      
      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
      it { response.body.should eq("mycallback(#{json})") }
    end
  end
  
  private
    def json_attributes(events, date)
      events.
        select { |e| e.start.to_date == date }.
        map    { |e| complete_attributes(e) }
    end

    def complete_attributes(e)
      s_id = e.session.nil? ? nil : e.session.id
      room = e.room ? e.room.name : nil
      e.attributes.merge(session_id: s_id, room: room)
    end
end
