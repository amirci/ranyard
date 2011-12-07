require 'spec_helper'

describe SponsorsController do

  let(:exceptions) { ['created_at', 'updated_at', 'conference_id'] }
  
  let(:sponsors)  { (1..10).map { |i| Fabricate(:sponsor) } }

  let(:conference) { mock_model(Conference, subdomain: nil, active: true) }
  
  before(:each) do
    controller.stub!(:active_conference).and_return(conference)
    conference.stub(:sponsors).and_return(sponsors)
  end
  
  it_behaves_like 'resource collection API read' do
    let(:symbol)    { :sponsors }
    let(:resources) { sponsors }
    let(:json)      { { sponsors: json_attributes(sponsors) }.to_json(:except => exceptions) }
  end

  private 
    def json_attributes(sponsors)
      sponsors.map { |s| s.attributes }
    end
  
  
end
