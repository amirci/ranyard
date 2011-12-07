class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_application_view_path
	before_filter :load_active_conference
  layout :layout_for_page
  
  unless PrdcRor::Application.config.consider_all_requests_local
    rescue_from ArgumentError, :with => :render_bad_request
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from Exception, :with => :redirect_root
  end
  
  def not_found
      raise ActionController::RoutingError.new('Not Found')
  end

  def bad_request(message = :nil)
      raise ArgumentError, message
  end

  private
    def get_conference_subdomain_from_request_url
      request.subdomains.last # in case people type www.west.prairiedevcon.com
    end

    # from: http://www.axehomeyg.com/2009/06/10/view-path-manipulation-for-rails-with-aop/
    def set_application_view_path
      ActionController::Base.application_view_path = request.subdomain
    end

    def load_active_conference
      @conference = active_conference
    end

    def layout_for_page
      layout_to_use = 'application'
      layout_to_use = @conference.subdomain unless @conference.nil? or @conference.subdomain.nil?
      layout_to_use
    end
  
    def redirect_root(exception = nil)
      Rails.logger.info "***** Exception #{exception.class}, redirecting to root: #{exception.message}" if exception
      redirect_to "/"
    end

    def active_conference
      matches = Conference.where(subdomain: request.subdomain, active:true)
      matches = Conference.where(subdomain: nil, active: true) if matches.empty?
      matches.first
    end
    
    def render_bad_request
      render :text => "400 Bad Request", :status => 400
    end

    def render_not_found
      render :text => "404 Not Found", :status => 404
    end

    def authenticate_user!
      unless current_user
        redirect_to log_in_path
        return
      end
    end
    
    def current_user  
      @current_user ||= User.find(session[:user_id]) if session[:user_id]  
    end  
    
    helper_method :current_user, :active_conference
  
end
