require 'spec_helper'

describe ConferenceStatus do
  
  describe ".last_update" do
    let(:models) { [Sponsor, Session, Event, Speaker, Room] }
    let(:date)   { DateTime.parse('Nov 7, 2001') }
    
    before do
      models.each_with_index do |m, i| 
        row = Fabricate(m.name.downcase.to_sym, updated_at: date + i)
        m.stub(:order).with(:updated_at).and_return([row])
      end
    end
      
    subject { ConferenceStatus.last_update }
    
    it { should == date + models.length - 1 }
  end
  
end
