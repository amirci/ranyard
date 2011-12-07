require 'spec_helper'

describe "sessions/show.html.haml" do
  before(:each) do
    @session = assign(:session, stub_model(Session,
      :title => "Title",
      :speaker => stub_model(Speaker, name: "Super Speaker"),
      :abstract => "Abstract"
    ))
    
    view.stub(:current_user).and_return(nil)
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Title/)
    rendered.should match(/Abstract/)
  end
end
