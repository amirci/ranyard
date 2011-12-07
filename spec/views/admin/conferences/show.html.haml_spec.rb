require 'spec_helper'

describe "conferences/show.html.haml" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference))
  end

  it "renders attributes in <p>" do
    render
  end
end
