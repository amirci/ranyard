require 'spec_helper'

describe SpeakersController do
  include SignInSpecHelper
  
  let(:conference) { stub_model(Conference) }
  
  let(:speakers) { (1..10).map { |i| stub_model(Speaker, valid_attributes.merge({id: i}))} }

  before(:each) do
    subject.stub!(:active_conference).and_return(conference)
    conference.stub(:speakers).and_return(speakers)
    speakers.stub(:order).with(:name).and_return(speakers)
  end
  
  it_behaves_like 'resource collection read' do
    let(:symbol)    { :speakers }
    let(:resources) { speakers }
    let(:json)      { { speakers: json_attributes(speakers) }.to_json(:except => exceptions) }
  end
    
  it_behaves_like 'resource single read' do
    before { Speaker.stub(:find).with("1").and_return(speakers.first) }
    let(:symbol)   { :speaker }
    let(:resource) { speakers.first }
    let(:json)     { { speaker: json_attributes(resource).first }.to_json(:except => exceptions) }
  end

  describe "#new" do
    before do
      sign_in
      speakers.stub(:build).and_return(speakers.first)
      get :new
    end
    it { should assign_to(:speaker).with(speakers.first) }
  end

  describe "#edit" do
    before do
      sign_in
      Speaker.stub(:find).with(speakers.first.id.to_s).and_return(speakers.first)
      get :edit, :id => speakers.first.id
    end
    it { should assign_to(:speaker).with(speakers.first) }
  end

  describe "#create" do
    let(:attr) { valid_attributes }
    
    before do 
      Speaker.stub(:new).with(attr).and_return(speakers.first)
      sign_in 
    end
    
    context "with valid params" do
      before do
        speakers.first.stub(:save).and_return(true)
        post :create, :speaker => attr
      end

      it { should assign_to(:speaker).with(speakers.first) }
      it { should set_the_flash.to('Speaker was successfully created.')}
      it { should redirect_to(speakers.first)}
    end

    context "with invalid params" do
      before do
        speakers.first.stub(:save).and_return(false)
        post :create, :speaker => attr
      end
      
      it { should assign_to(:speaker).with(speakers.first) }
      it { should render_template(:new)}
    end
  end

  describe "#update" do
    let(:update) { speakers.last.attributes.update('id' => speakers.last.id.to_s) }
    
    before do 
      Speaker.stub(:find).with(speakers.first.id.to_s).and_return(speakers.first)
      sign_in 
    end
    
    context "with valid params" do
      before do
        speakers.first.stub(:update_attributes).with(update).and_return(true)
        put :update, :id => speakers.first.id, :speaker => speakers.last.attributes
      end

      it { should redirect_to(speakers.first) }
      it { should assign_to(:speaker).with(speakers.first) }
      it { should set_the_flash.to('Speaker was successfully updated.') }
    end

    context "with invalid params" do
      before do
        speakers.first.stub(:update_attributes).with(update).and_return(false)
        put :update, :id => speakers.first.id, :speaker => speakers.last.attributes
      end

      it { should assign_to(:speaker).with(speakers.first) }
      it { should render_template('edit') }
    end
  end

  describe "#destroy" do
    before do
      sign_in 
      Speaker.stub(:find).with(speakers.first.id.to_s).and_return(speakers.first) 
      speakers.first.stub(:destroy)
      post :destroy, :id => speakers.first.id
    end

    it { should redirect_to(speakers_url) }
  end

  private
    def valid_attributes
      { 'name'    => "Super Speaker", 
        'email'   => "sspeaker@pres.com", 
        'bio'     => "Very long bio", 
        'blog'    => "myblog", 
        'website' => "mywebsite", 
        'twitter' => "sspeaker", 
        'picture' => "sspeaker.jpg"}
    end
    
    def json_attributes(speakers)
       ([] << speakers).
          flatten.
          map { |s| replace_name_with_first_and_last(s.attributes) }
    end
  
    def replace_name_with_first_and_last(attrib)
      names = attrib.delete('name').split(' ')
      attrib.merge(first_name: names.shift, last_name: names.join(' '))
    end
    
    def exceptions
      ['created_at', 'updated_at', 'conference_id']
    end
end
