require 'spec_helper'

describe EventsController do
  include SignInSpecHelper

  let(:events) { (1..10).map { |i| stub_model(Event, start: "Nov 21 2011 #{8+i}:00", finish: "Nov 21 2011 #{8+i+1}:00") } }

  let(:conference) { double(Conference, start: DateTime.parse('Nov 21 2011')) }

  let(:sessions) { (1..20).map { |i| stub_model(Session) } }

  before(:each) do
    subject.stub!(:active_conference).and_return(conference)
    conference.stub(:events).and_return(events)

    events.stub(:order).with(:start).and_return(events)

    conference.stub(:sessions).and_return(sessions)
    sessions.stub(:order).with(:title).and_return(sessions)

    Event.stub(:find).with("1").and_return(events.first)
    sign_in
  end
  
  describe "#index" do
    before { get :index }

    it { should render_template(:index) }
    it { should assign_to(:events).with(events) }
  end
  
  describe "#show" do
    before { get :show, id: 1 }
    
    it { should render_template(:show) }
    it { should assign_to(:event).with(events.first) }
  end

  describe "#edit" do
    before do
      get :edit, id: 1 
    end
    
    it { should render_template(:edit) }
    it { should assign_to(:event).with(events.first) }
    it { should assign_to(:sessions).with(sessions) }
  end

  
  describe "#update" do
    let(:s) { stub_model(Session, id: 98) }
    
    let(:values) { {"start" => '2010-07-01 10:00', 
                    "finish" => '2010-07-01 11:00', 
                    "custom" => "Prizes" } }

    context "update is successful" do
      before do
        events.first.should_receive(:update_attributes).with(values).and_return(true)
        events.first.should_receive(:session=).with(s)
        Session.stub(:find).with(s.id.to_s).and_return(s)
        put :update, id: 1, event: values, session: { id: s.id }
      end

      it { should redirect_to(events.first) }
    end

    context "update is not successful" do
      before do
        events.first.should_receive(:update_attributes).with(values).and_return(false)
        put :update, id: 1, event: values
      end

      it { should render_template(:edit) }
    end
  end
  
  describe "#destroy" do
    before do
      events.first.should_receive(:destroy)
      put :destroy, id: 1
    end
    
    it { should redirect_to(events_path)}
  end
  
  describe "#new" do
    let(:date) { DateTime.parse('Nov 28 2011') }
    
    before do 
      get :new, date: date
    end
    
    it { should render_template(:new) }
    it { should assign_to(:event).with_kind_of(Event) }
    it { assigns[:event].start.should == date }
  end
  
  describe "#create" do
    let(:se) { double(Session, id: 98) }
    
    let(:values) { {"start" => '2010-07-01 10:00', 
                    "finish" => '2010-07-01 11:00' } }
    
    let(:event) { stub_model(Event) }
    
    before do
      events.stub(:create).with(values).and_return(event)
      event.should_receive(:session=).with(se)
      Session.stub(:find).with(se.id.to_s).and_return(se)
      post :create, event: values, session: { id: se.id } 
    end
    
    it { should redirect_to(event) }
  end
end
