require 'spec_helper'

describe TimeSlot do

  let(:start) { DateTime.parse('10:00') }
  
  let(:finish) { DateTime.parse('11:00') }
  
  subject { TimeSlot.new(start: start, finish: finish) }

  let(:same) { TimeSlot.new(start: start, finish:finish) }
  
  let(:diff) { TimeSlot.new(start: start + 10, finish: finish + 10) }
  
  its(:start) { should eq(start) }
  
  its(:finish) { should eq(finish) }
  
  it { should eq(same) }
  
  it { should_not eq(diff) }
  
  describe "#<=>" do
    context 'When are equal' do
      it { (subject <=> same).should == 0 }
    end
    context 'When is greater' do
      it { (subject <=> diff).should == -1 }
    end
    context 'When is lower' do
      it { (diff <=> subject).should == 1 }
    end
    context 'When has same start and finish is lower' do
      it { (subject <=> TimeSlot.new(start: subject.start, finish: subject.finish - 0.5.hours )).should == -1 }
    end
    context 'When has same start and finish is greater' do
      it { (subject <=> TimeSlot.new(start: subject.start, finish: subject.finish + 0.5.hours )).should == 1 }
    end
  end
  
  describe ".parse" do
    subject { TimeSlot.parse('08:00 - 09:00') }
    
    its(:start)  { should eq(DateTime.parse('08:00')) }
    its(:finish) { should eq(DateTime.parse('09:00')) }
  end
  
end