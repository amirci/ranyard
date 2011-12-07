require 'spec_helper'

describe "conferences/new.html.haml" do
  before(:each) do
    assign(:conference, stub_model(Conference).as_new_record)
  end

  it "renders new admin_conference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => conferences_path, :method => "post" do
    end
  end
end
