require 'spec_helper'

describe "conferences/edit.html.haml" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference))
  end

  it "renders the edit admin_conference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => conferences_path(@conference), :method => "post" do
    end
  end
end
