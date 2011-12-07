require 'spec_helper'

describe Speaker do
  it { should have_db_column(:bio).of_type(:text)        }
  it { should have_db_column(:blog).of_type(:string)     }
  it { should have_db_column(:email).of_type(:string)    }
  it { should have_db_column(:location).of_type(:string) }
  it { should have_db_column(:name).of_type(:string)     }
  it { should have_db_column(:picture).of_type(:string)  }
  it { should have_db_column(:twitter).of_type(:string)  }
  it { should have_db_column(:website).of_type(:string)  }
  
  it { should have_many(:sessions).dependent(:destroy).through(:assignments) }

  it { should belong_to(:conference) }
  
  context 'Adding duplicate sessions' do
    let(:session1) { stub_model(Session, title: 'Session 1') }
    let(:session2) { stub_model(Session, title: 'Session 2') }

    before { subject.sessions << session1 << session2 << session1 }
    
    its(:sessions) { should eq([session1, session2]) }
  end
  
end
