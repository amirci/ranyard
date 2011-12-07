require 'spec_helper'

describe Conference do
  it { should have_db_column(:name).of_type(:string)  }
  it { should have_db_column(:start).of_type(:date)   }
  it { should have_db_column(:finish).of_type(:date)      }
  it { should have_db_column(:active).of_type(:boolean)   }
  it { should have_db_column(:subdomain).of_type(:string) }
  it { should have_db_column(:venue).of_type(:string)     }
  it { should have_db_column(:city).of_type(:string)      }

  it { should have_many(:speakers) }
  it { should have_many(:sessions) }
  it { should have_many(:rooms)    }
  it { should have_many(:events)   }
  it { should have_many(:sponsors) }
  
  let(:start) { DateTime.parse('Nov 21 2011') }

  describe "#days" do
    subject { Conference.new(start: start, finish: start + 3) }
    its(:days) { should == (start..start + 3).to_a }
  end
  
  describe "#events_for" do
    let(:conference) { Conference.new(start: start, finish: start + 3) }
    
    let(:events) { (1..10).map { stub_model(Event, start: start + 1) } }
    
    before { conference.stub(:events).and_return(events) }
    
    context 'When using a date' do
      subject { conference.events_for(start + 1) }
      it { should == events }
    end
    
    context 'When using a date outside range' do
      subject { conference.events_for(start + 4) }
      it { should be_empty }
    end

    context 'When using a date index' do
      subject { conference.events_for(2) }
      it { should == events }
    end

    context 'When using a date index outside range' do
      subject { conference.events_for(5) }
      it { should be_empty }
    end

  end
  
end
