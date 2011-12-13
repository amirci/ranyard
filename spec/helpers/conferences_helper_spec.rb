require 'spec_helper'

describe ConferencesHelper do
  
  let(:date) { Date.new }    

  describe ".format_start" do
    it { helper.format_start(date).should == date.strftime('%b %e, %Y') }
  end
  
  describe ".format_finish" do
    it { helper.format_finish(date).should == date.strftime('%b %e, %Y') }
  end

  describe ".format_active" do
    context "when active" do
      it { helper.format_active(true).should == "active" }
    end
    
    context "when not active" do
      it { helper.format_active(false).should == "" }
    end
  end

  describe ".format_days" do
    
    let(:conf) { double(Conference, start: Date.parse('Nov 21 2011'), finish: Date.parse('Nov 23 2011')) }
    let(:days) { (21..23).map { |d| DateTime.parse("Nov #{d}, 2011") } }
    
    before { conf.stub(:days).and_return(days) }
    
    it { helper.format_days(conf).should == 'November 21, 22 & 23 2011' }
  end
  
end
