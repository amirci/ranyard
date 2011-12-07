require 'spec_helper'

describe "speakers/edit.html.haml" do
  before(:each) do
    @speaker = assign(:speaker, stub_model(Speaker))
  end

  it "renders the edit speaker form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => speakers_path(@speaker), :method => "post" do
    end
  end
end
