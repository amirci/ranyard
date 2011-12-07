require "spec_helper"

describe ReportsController do
  describe "routing" do
    subject { get("/reports/info/") }
    it { should route_to("reports#info")  }
  end
end
