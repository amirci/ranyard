require "spec_helper"

describe ConferencesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin").should route_to("conferences#index")
    end

    it "routes to #index" do
      get("/conferences").should route_to("conferences#index")
    end

    it "routes to #new" do
      get("/conferences/new").should route_to("conferences#new")
    end

    it "routes to #show" do
      get("/conferences/1").should route_to("conferences#show", :id => "1")
    end

    it "routes to #edit" do
      get("/conferences/1/edit").should route_to("conferences#edit", :id => "1")
    end

    it "routes to #create" do
      post("/conferences").should route_to("conferences#create")
    end

    it "routes to #update" do
      put("/conferences/1").should route_to("conferences#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/conferences/1").should route_to("conferences#destroy", :id => "1")
    end

  end
end
