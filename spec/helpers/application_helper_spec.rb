require 'spec_helper'

describe ApplicationHelper do

  let(:conference) { double(Conference) }
  
  describe '.markdown_parse' do
    let(:markdown) { "**This is** _some_ markdown\n\n##Oh Yeah!" }

    subject { markdown_parse(markdown) }
    
    it { should eq(BlueCloth.new(markdown).to_html) }
  end

  describe '.admin_stylesheet' do
    subject { admin_stylesheet }
    
    before { stub!(:active_conference).and_return(conference) }
    
    context 'when is default conference' do
      before { conference.stub(:subdomain).and_return(nil) }
      it { should eq stylesheet_link_tag("application_east", debug: false) }
    end
    
    context 'when is west conference' do
      before { conference.stub(:subdomain).and_return('west') }
      it { should eq stylesheet_link_tag("application_west", debug: false) }
    end
    
  end
  
end
