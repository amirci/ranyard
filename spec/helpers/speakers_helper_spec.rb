require 'spec_helper'

describe SpeakersHelper do
  
  describe '.sort_by_last_name' do
    subject { sort_by_last_name(speakers) }

    context 'When speakers have first and last name' do
      let(:speakers) { (1..10).collect { |i| stub_model(Speaker, name: "Awesome Speaker_#{10-i}")} }
      it { should eq(speakers.reverse) }
    end
    
    context 'When speakers has no last name' do
      let(:speakers) { (1..10).collect { |i| stub_model(Speaker, name: "Awesome_#{10-i}")} }
      it { should eq(speakers.reverse) }
    end
    
    context 'When speakers has a middle name' do
      let(:speakers) { (1..10).collect { |i| stub_model(Speaker, name: "Awesome Super Speaker_#{10-i}")} }
      it { should eq(speakers.reverse) }
    end

  end
  
  describe '.icons' do
    let(:speaker) { double(Speaker, name: "Super Speaker", email: 'speaker@email.com', website: 'www.speaker.com', twitter: 'speaker', blog: 'super.blog.com') }

    [:email, :website, :blog, :twitter].each do |kind|
       [nil, ""].each do |val|
         context "When speaker's #{kind} is #{val.nil? ? 'nil' : 'empty'}" do
           before { speaker.stub(kind).and_return(val) }
           
           subject { icons(speaker) }

           it { should_not include("icon_#{kind}") }
         end
      end
    end
  end

  describe '.bio' do
    let(:speaker) { double(Speaker, name: 'Super speaker', bio: 'Some super long bio') }

    subject { bio(speaker) }

    context 'When speaker has bio' do
      before { self.stub!(:markdown_parse).and_return('Markdown') }

      it { should eq(content_tag(:div, 'Markdown', class: 'bio')) }
    end
    
    context 'When speaker has no bio yet' do
      before { speaker.stub(:bio).and_return(nil) }
      
      it { should be(nil) }
    end
  end
  
  describe '.sessions' do
    let(:sess) { 3.times.collect { |i| stub_model(Session, title: "Session #{i}") } }

    let(:speaker) { double(Speaker, name: 'Super speaker', sessions: sess) }

    let(:room)  { double(Room, name: 'Cornucopia') }

    let(:event) { double(Event, start: DateTime.parse('Nov 21, 2011 10:00 CDT'), 
                                finish: DateTime.parse('Nov 21, 2011 11:15 CDT'), 
                                room: room) }

    let(:formatted) { "Mon, 10:00, room Cornucopia" }

    subject { sessions(speaker) }

    context 'When speaker has sessions' do

      context 'When session has no schedule' do
        let(:expected) do
          content_tag(:dl, nil, class: 'sessions') do
            sess.collect { |s| content_tag(:dt, "Session:") + content_tag(:dd, link_to(s.title, s)) }.reduce(:+)
          end
        end

        it { should eq(expected) }
      end

      context 'When session has schedule' do
        let(:expected) do
          content_tag(:dl, nil, class: 'sessions') do
            sess.collect do |s| 
              content_tag(:dt, "Session:") + 
              content_tag(:dd, link_to("#{s.title} (#{formatted})", s)) 
            end.reduce(:+)
          end
        end

        before { sess.each { |s| s.stub(:event).and_return(event) } }
        before { self.stub!(:event_format).with(event).and_return(formatted) }

        it { should eq(expected) }
      end

    end
    
    context 'When speaker has no sessions yet' do
      before { speaker.stub(:sessions).and_return([]) }
      
      it { should be(nil) }
    end
  end
  
  describe '.picture' do
    let(:speaker) { double(Speaker, name: "Super Speaker", picture: 'withglasses.jpg') }

    let(:prefix) { "speakers" }
    
    subject { picture(speaker) }

    context 'speaker has a picture' do
      let(:expected) { image_tag("#{prefix}/#{speaker.picture.downcase}", class: 'pic', alt: speaker.name) }
      
      it { should == expected }
    end
    
    context 'speaker has no picture' do
      let(:expected) { image_tag("#{prefix}/missing.jpg", class: 'pic', alt: speaker.name) }

      before { speaker.stub(:picture).and_return(nil) }
      
      it { should == expected }
    end
  end
end
