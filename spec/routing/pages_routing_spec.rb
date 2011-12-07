require "spec_helper"

describe PagesController do
  describe "routing" do

    static_pages = ['about', 
                    'privacy', 
                    'toc', 
                    'registration', 
                    'develop', 
                    'west']

    static_pages.each do |page|
      it "routes to ##{page}" do
        get("/#{page}").should route_to("pages#show", :id => page)
      end

      it "generates the expected URL via the pages_path(:id) helper" do
        page_path(page).should eql("/#{page}")
      end
    end

  end
end
