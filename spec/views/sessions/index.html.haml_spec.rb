require 'spec_helper'

# apparently needed for passing mocks to 'simple_form_for' or for using 
# custom path helpers off of Mock objects (?)
# class RSpec::Mocks::Mock
#   extend ActiveModel::Naming
#   include ActiveModel::Conversion
#   def persisted?
#     false
#   end
# end
# 

describe "sessions/index.html.haml" do
  let(:tags) { (1..5).collect { |i| ActsAsTaggableOn::Tag.new(name: "tag#{i}") } }
  
  let(:speakers) { (1..2).collect { |i| stub_model(Speaker, name: "Super Speaker #{i}", id: i) } }
  
  let(:sessions) do
    (1..2).collect do |i| 
      stub_model(Session,
                :id => i,
                :title => "Title",
                :speakers => speakers,
                :abstract => "Abstract",
                :tags => [],
                :event => nil)
    end
    
  end
  
  let(:expected_speakers) { speakers.collect { |s| s.name }.join(', ') }

  let(:expected_tags) { [].empty? ? "TBD" : tags.collect { |t| t.name.upcase }.join(', ') }

  before(:each) do
    assign(:sessions, sessions)
    assign(:tags, [])
    view.stub!(:current_user).and_return(nil)
  end

  it "renders a list of sessions" do
    render
    assert_select "h3"        , :text => "Title", :count => 2
    assert_select ".speakers" , :text => expected_speakers, :count => sessions.count
    assert_select ".tags"     , :text => expected_tags, :count => sessions.count
    assert_select ".abstract" , :text => "Abstract", :count => sessions.count
  end
end
