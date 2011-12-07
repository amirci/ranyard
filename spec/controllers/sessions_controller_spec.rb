require 'spec_helper'

describe SessionsController do
  include SignInSpecHelper

  let(:exceptions) { ['created_at', 'updated_at', 'event_id', 'upvotes', 'downvotes', 'planning_to_attend', 'conference_id'] }
    
  let(:conference) { mock_model(Conference, subdomain: nil) }

  let(:speakers) { (1..10).map { |i| stub_model(Speaker, id: i, name: "Speaker #{i}")} }

  let(:tags) { %w(Ruby Design Mobile) }  

  let(:sessions) do
    (1..10).map do |i| 
      stub_model(Session, valid_attributes(i))
    end
  end
  
  let(:session_1) { sessions.first }
  
  before(:each) do
    subject.stub!(:active_conference).and_return(conference)
    conference.stub(:sessions).and_return(sessions)
    conference.stub(:speakers).and_return(speakers)
    sessions.stub(:order).with('title').and_return(sessions)
    sessions.stub(:tag_counts_on).with(:tags).and_return(tags)

    Session.stub(:find).with(session_1.id.to_s).and_return(session_1)
  end

  it_behaves_like 'resource collection read' do
    let(:symbol)    { :sessions }
    let(:resources) { sessions }
    let(:json)      { { sessions: sessions.collect { |s| json_attributes(s) } }.to_json(:except => exceptions) }
  end

  it_behaves_like 'resource single read' do
    let(:symbol)   { :session       }
    let(:resource) { sessions.first }
    let(:json)     { { session: json_attributes(resource) }.to_json(:except => exceptions) }
  end

  describe "#index" do
    
    before do 
      sign_in
      get :index
    end
    
    it { should assign_to(:tags).with(tags) }
  end
  
  describe "#new" do
    let(:new_session) { mock_model(Session) }
    
    before do
      Session.stub(:new).and_return(new_session)
      sign_in 
      get :new 
    end
    
    it { should assign_to(:session).with(new_session) }
    it { should assign_to(:speakers).with(speakers) }
    it { should render_template('new') }
  end

  describe "#edit" do
    before do
      sign_in 
      get :edit, :id => session_1.id 
    end
    
    it { should assign_to(:session).with(session_1) }
    it { should assign_to(:speakers).with(speakers) }
    it { should render_template('edit') }
  end

  describe "#create" do
    let(:new_session) { mock_model(Session) }

    let(:params) do 
      valid_attributes.
          merge('speakers' => ['1'], 'planning_to_attend' => '0').
          reject { |k, v| k == 'id' } 
    end
    
    before do
      Session.stub(:new).with(params.merge('conference' => conference)).and_return(new_session)
    end
    
    context "with valid params" do
      before do
        new_session.stub(:save).and_return(true)
        sign_in
        post :create, :session => params
      end

      it { should assign_to(:session).with(new_session) }
      it { should redirect_to(new_session) }
      it { should set_the_flash.to('Session was successfully created.')}
    end

    context "with invalid params" do
      before do
        new_session.stub(:save).and_return(false)
        sign_in
        post :create, :session => params
      end

      it { should assign_to(:session).with(new_session) }
      it { should render_template('new') }
    end
  end

  describe "#update" do
    let(:params) do 
      sessions.last.
          attributes.
          merge('planning_to_attend' => '0').
          reject { |k, v| k == 'id' || k == 'event_id' } 
    end
    
    before { sign_in }

    context "valid params" do
      before do
        session_1.stub(:update_attributes).with(params).and_return(true)
        put :update, :id => session_1.id, :session => params
      end

      it { should redirect_to(session_1) }
      it { should assign_to(:session).with(session_1) }
      it { should set_the_flash.to('Session was successfully updated.') }
    end

    context "invalid params" do
      before do
        session_1.stub(:update_attributes).with(params).and_return(false)
        put :update, :id => session_1.id, :session => params
      end

      it { should assign_to(:session).with(session_1) }
      it { should render_template('edit') }
    end
  end

  describe "#destroy" do
    before do
      sign_in 
      session_1.stub(:destroy)
      post :destroy, :id => session_1.id
    end

    it { should redirect_to(sessions_url) }    
  end

  describe "#attending" do
    let(:attending_json) { { :id => 1 }.to_json }

    context "when format is html" do
      before { post :attending, :id => 1 }

      it { should redirect_to(:sessions) }
    end

    context "when format is json" do
      before {post :attending, :id => 1, :format => :json}

      it { should respond_with_content_type(:json) }
      it { should respond_with(:success) }
      it { response.body.should eq(attending_json) }
    end

    context "when format is js" do
      before {post :attending, :id => 1, :format => :js, :callback => :mycallback}

      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
      it { response.body.should eq("mycallback(#{attending_json})") }
    end
  end

  describe "#attending" do
    let(:not_attending_json) { { :id => 1 }.to_json }

    context "when format is html" do
      before { delete :attending, :id => 1 }
      it { should redirect_to(:sessions) }
    end

    context "when format is json" do
      before {delete :attending, :id => 1, :format => :json}

      it { should respond_with_content_type(:json) }
      it { should respond_with(:success) }
      it { response.body.should eq(not_attending_json) }
    end

    context "when format is js" do
      before {delete :attending, :id => 1, :format => :js, :callback => :mycallback}

      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
      it { response.body.should eq("mycallback(#{not_attending_json})") }
    end
  end

  describe "#attendance" do
    let(:sessions) { (1..10).map { |i| mock_model(Session, id: i, planning_to_attend: i) } }

    before do
      sessions.stub(:order).with('planning_to_attend DESC').and_return(sessions.reverse)
      sign_in 
      get :attendance
    end
    
    it { should respond_with_content_type(:html) }
    it { should respond_with(:success) }
    it { should assign_to(:sessions).with(sessions.reverse) }
  end

  private
    def valid_attributes(i = 0, speaker = nil)
      { 'id'       => i,
        'title'    => "New session #{i}", 
        'abstract' => "Very nice session #{i}",
        'tag_list' => %w[Ruby Design Mobile],
        'event'    => i == 0 ? nil : stub_model(Event, id: i, 
                                                start: 'Nov 1, 2011 8:00', 
                                                finish: 'Nov 3, 2011 9:00',
                                                room: stub_model(Room, name: "Room_#{i}")) ,
        'planning_to_attend'  => 0,
        'speakers' => i == 0 ? [speakers[0]] : [speakers[i-1]] }
    end

    def json_attributes(session)
      session.attributes.merge(
        speakers: session.speakers.collect(&:id),
        tags: session.tag_list.sort_by(&:upcase),
        start: session.event.nil?  ? nil : session.event.start,
        finish: session.event.nil? ? nil : session.event.finish,
        room: session.event.nil? ? nil : session.event.room.name
      ) 
    end
end
