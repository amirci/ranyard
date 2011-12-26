require 'spec_helper'

describe SessionsHelper do

  describe '.schedule' do
    let(:room)    { double(Room, name: 'Colagen') }
    let(:event)   { double(Event, start: DateTime.parse('2011-11-22 9:00 CDT'), room: room) }
    let(:session) { double(Session, title: 'Super session', event: event, id: 1) }
    let(:formatted) { "Tue, 09:00, room Colagen" }
    
    subject { schedule(session) }

    context 'When session has schedule' do
      before do 
        self.stub!(:event_format).with(event).and_return(formatted)
        self.stub!(:schedule_path).and_return("schedule")
        self.stub!(:link_to).with(formatted, "schedule").and_return("link")
      end
      
      it { should eq "link" }
    end

    context 'When session has no schedule yet ' do
      before { session.stub(:event).and_return(nil) }
      
      it { should eq(nil) }
    end
  end
  
end
