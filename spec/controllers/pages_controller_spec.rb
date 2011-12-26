require "spec_helper"

describe PagesController do

  static_pages = %w(develop)
  supported_subdomains = [nil, 'west']

  supported_subdomains.each do |subdomain|
    static_pages.each do |page|

      describe "GET /#{page}" do
        let(:conference) { double(Conference, :subdomain => subdomain) }
        
        before do
          Conference.stub(:where).with(subdomain: subdomain, active: true).and_return([conference])
          @controller.request.stub(:subdomain).and_return(subdomain)
          get :show, :id => page
        end

        it { should respond_with :success  }
        it { should render_template "layouts/#{subdomain}"   } unless subdomain.nil?
        it { should render_template "pages/#{page}"   }
        it { should assign_to(:conference).with(conference) }
      end
    end
  end

end
