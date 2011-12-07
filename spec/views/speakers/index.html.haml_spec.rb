require 'spec_helper'

describe "speakers/index.html.haml" do
  before(:each) do
    assign(:speakers, [stub_model(Speaker, name: 'Speaker Super1'), stub_model(Speaker, name: 'Speaker Super2')])
    view.stub!(:current_user).and_return(nil)
  end

  it "renders a list of speakers" do
    render
  end
end
