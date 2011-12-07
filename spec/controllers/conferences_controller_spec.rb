require 'spec_helper'

describe ConferencesController do
  include SignInSpecHelper
  
  def valid_attributes
    {name: "C1", start: "Nov 1, 2010", end: "Nov 3, 2010", active: true}
  end

  before(:each) do
    sign_in
    @conferences = (1..10).collect { |i| stub_model(Conference, id: i, name: "Conf_#{i}", start: "Nov #{i}, 2010", finish: "Nov #{i+2}", active: false)}      
    Conference.stub(:all).and_return(@conferences)
    Conference.stub(:find).with("1").and_return(@conferences.first)
  end
  
  describe "#index" do
    before { get :index }
    
    it { should render_template(:index) }
    it { should assign_to(:conferences).with(@conferences) }
  end

  describe "#show" do
    before { get :show, :id => 1 }  
    
    it { should render_template(:show) }
    it { should assign_to(:conference).with(@conferences.first) }
  end

  describe "#new" do
    before { get :new }
    
    it { should render_template(:new) }
    it { should assign_to(:conference).with_kind_of(Conference) }
  end

  describe "#edit" do
    before { get :edit, :id => 1 }
    
    it { should render_template(:edit) }
    it { should assign_to(:conference).with(@conferences.first) }
  end

  describe "#create" do
    before do
      values = {"name" => "C1", "start" => '2010-07-01', "finish" => '2010-07-01', "active" => true}
      @conference = stub_model(Conference)
      @conference.stub(:save).and_return(true)
      Conference.stub(:new).with(values).and_return(@conference)
      post :create, "conference" => values
    end
    
    it { should redirect_to(@conference) }
    it { should assign_to(:conference).with(@conference) }
  end
  
  describe "#update" do
    before do
      values = {"name" => "C1", "start" => '2010-07-01', "finish" => '2010-07-01', "active" => true}
      Conference.stub(:find).with(1).and_return(@conferences.first)
      @conferences.first.stub(:update_attributes).with(values).and_return(true)
      post :update, :id => 1, "conference" => values
    end
    
    it { should redirect_to(@conferences.first) }
    it { should assign_to(:conference).with(@conferences.first) }
  end

  describe "#destroy" do
    before do
      @conferences.first.stub(:destroy)
      post :destroy, :id => 1
    end
    
    it { should redirect_to(conferences_path) }
    it { should assign_to(:conference).with(@conferences.first) }
  end
  
  describe "#last_update" do
    let(:expected) { DateTime.parse('Nov 7, 2011') }
    let(:json) { { last_update: expected }.to_json }

    before { ConferenceStatus.stub(:last_update).and_return(expected) }

    context "when format is json" do
      before { get :last_update, :format => :json }
      it { should respond_with_content_type(:json) }
      it { should respond_with(:success) }
      it { response.body.should be_json_eql(json) }
    end

    context "when format is js" do
      before { get :last_update, :format => :js, :callback => :mycallback }
      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
      it { response.body.should match /^mycallback\(.*\)$/ }
      it { response.body.should == "mycallback(#{json})" }
    end
  end
  
end
