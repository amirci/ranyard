require 'spec_helper'

describe AccountsController do
  include SignInSpecHelper
  
  describe "#new" do
    before do
      get :new
    end
    
    it { should render_template(:new) }
  end

  describe "#create" do
    before do
      @user = sign_up 'test@email.com', 'test'
    end

    context "Succesful login" do
      before { post :create, :email => 'test@email.com', :password => 'test' }
      it { should redirect_to(root_url) }
      it { should set_session(:user_id).to(@user.id)}
    end
    
    context "Invalid email" do
      before { post :create, :email => 'forgery@email.com', :password => 'test' }
      it { should render_template(:new) }
      it { should set_the_flash.now.to('Invalid email or password.')}
    end

    context "Invalid pwd" do
      before { post :create, :email => 'test@email.com', :password => 'forgery' }
      it { should render_template(:new) }
      it { should set_the_flash.now.to('Invalid email or password.')}
    end
  end

  describe "#destroy" do
    before do
      @request.session[:user_id] = 1
      post :destroy, :id => 1
    end
    
    it { should redirect_to(root_url) }
    it { should set_session(:user_id).to(nil) }
  end

end
