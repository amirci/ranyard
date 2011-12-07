require 'spec_helper'

describe "conferences/index.html.haml" do
  before(:each) do
    assign(:conferences, 
           (1..10).collect { |i| stub_model(Conference, 
                                            name: "Conf_#{i}", 
                                            start: "Jul #{i}, 2010", 
                                            finish: "Jul #{i + 2}, 2010") })
  end

  it "renders a list of conferences" do
    render
  end
end
