require 'spec_helper'

describe Event do

  it { should have_db_column(:start).of_type(:datetime)  }
  it { should have_db_column(:finish).of_type(:datetime) }
  it { should have_db_column(:custom).of_type(:text) }
  it { should have_db_column(:main).of_type(:boolean) }

  it { should have_one(:session) }
  it { should belong_to(:room)   }
  it { should belong_to(:conference) }
  
  describe "#slot" do
    
    let(:start)    { DateTime.parse('Nov 21 10:00') }
    let(:finish)   { DateTime.parse('Nov 21 11:00') }
    let(:expected) { TimeSlot.new(start: start, finish: finish) }

    subject { Event.new(start: start, finish: finish) }
    
    its(:slot) { should == expected }
  end
end
