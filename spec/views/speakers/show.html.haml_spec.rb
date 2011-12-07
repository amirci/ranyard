require 'spec_helper'

describe "speakers/show.html.haml" do
  before(:each) do
    @speaker = assign(:speaker, stub_model(Speaker))
  end

  it "renders attributes in <p>" do
    render
  end
end
