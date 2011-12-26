require 'spec_helper'

describe ScheduleHelper do

  let(:slots)   { (1..5).collect { |i| TimeSlot.new(start: DateTime.parse("#{10 + i}:00"), finish: DateTime.parse("#{10 + i + 1  }:00")) } } 
  let(:rooms)   { (1..5).collect { |i| stub_model(Room, name: "Room #{i}") } }
  let(:slot)    { slots.first  }
  let(:session) { stub_model(Session, title: 'Nice session!') }
  let(:event)   { stub_model(Event, room: rooms.first, custom: nil) }
  
  describe ".event_title" do
    context 'when event is nil' do
      subject { event_title(nil) }
      it { should == '-' }
    end
    
    context 'when event has no session' do
      before { event.session = nil }
      subject { event_title(event) }
      it { should be_nil }
    end
    
    context 'when event has a session' do
      subject { event_title(event) }
      let(:expected) { link_to('Nice session!', session) + link_to("", "*", name: "session_#{session.id}") }
      before do 
        stub!(:current_user).and_return(nil)
        event.stub(:session).and_return(session) 
      end
      it { should == expected }
    end

    context 'when event has a session and is admin' do
      subject { event_title(event) }
      
      let(:expected) do
        link_to('Nice session!', session) + 
        link_to("", "*", name: "session_#{session.id}") +
        content_tag(:div, "(#{session.planning_to_attend})", class: 'attending')
      end
      
      before do
        stub!(:current_user).and_return(double(User))
        event.stub(:session).and_return(session) 
      end
      
      it { should == expected }
    end
  end
  
  describe ".format_slot" do  
    let(:slot)     { slots.last }  
    let(:expected) { slot.start.strftime('%I:%M') + ' to ' + slot.finish.strftime('%I:%M') }
                     
    it { helper.format_slot(slot).should == expected }
  end

  describe ".schedule_headers" do
    let(:expected) do
      content_tag(:tr, nil) do
        content_tag(:th, 'Time') +
        rooms.collect { |room| content_tag(:th, room.name, class: 'room') }.reduce(:+)
      end
    end
    
    it { helper.schedule_headers(rooms).should == expected }
  end
  
  describe ".schedule_events" do
    let(:events)  do
      slots.map do |slot|
        rooms.map do |room|
          stub_model(Event, room: room, start: slot.start, finish:slot.finish)
        end
      end.flatten
    end 
    
    let(:expected) do
      slots.sort_by { |s| s.start }.collect do |slot|
        content_tag(:tr, nil) do
          content_tag(:td, format_slot(slot), class: 'slot') +
          helper.event_cells(events.select { |e| e.slot == slot }, rooms)
        end
      end.reduce(:+)
    end
    
    it { helper.schedule_events(events, rooms).should == expected }
  end
  
  describe ".event_cells" do
    context "when is a main event" do
      let(:events) { [stub_model(Event, main:true, custom: 'Breakfast')] }
      
      let(:expected) { content_tag(:td, event_title(events.first), class: "main_event", colspan: rooms.count) }
        
      it { helper.event_cells(events, rooms).should == expected }
    end
    
    context 'when is a regular session' do
      let(:events) do 
        e = stub_model(Event)
        e.stub(:session).and_return(session)
        [e]
      end
      
      let(:expected) do
        rooms.collect do |room|
          e = events.select { |e| e.room == room }.first
          content_tag(:td, event_title(e), class: 'event')
        end.reduce(:+)
      end
      
      it { helper.event_cells(events, rooms).should == expected }
    end
  end
  
end
