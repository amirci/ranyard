require "spec_helper"

describe InfoRequestsController do
  describe "routing" do

    it "sends an information request" do
      post("/west").should route_to("info_requests#create")
    end

  end
end
