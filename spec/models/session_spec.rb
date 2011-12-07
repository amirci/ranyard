require 'spec_helper'

describe Session do
  it { should validate_presence_of(:title)    }
  it { should validate_presence_of(:abstract) }
  
  it { should have_db_column(:title).of_type(:string)  }
  it { should have_db_column(:abstract).of_type(:text) }
                
  it { should have_many(:speakers).through(:assignments) }  

  it { should belong_to(:conference) }
  
  context 'Adding duplicate speakers' do
    let(:speaker1) { stub_model(Speaker, name: 'Speaker 1') }
    let(:speaker2) { stub_model(Speaker, anme: 'Speaker 2') }

    before { subject.speakers << speaker1 << speaker2 << speaker1 }
    
    its(:speakers) { should eq([speaker1, speaker2]) }
  end

  its(:planning_to_attend) { should eq(0) }

end
