class PagesController < HighVoltage::PagesController
  unless PrdcRor::Application.config.consider_all_requests_local
    rescue_from Exception, :with => :redirect_root
  end
end
