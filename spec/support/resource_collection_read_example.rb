
shared_examples_for "resource collection read" do 
  describe "#index" do
    context "when format is html" do
      before { get :index }
      it { should assign_to(symbol).with(resources) }
      it { should render_template('index') }
    end
  end
  
  it_behaves_like 'resource collection API read'  
end

shared_examples_for "resource collection API read" do
  
  describe "#index" do
    context "when format is json" do
      before { get :index, :format => :json }
      it { should respond_with_content_type(:json) }
      it { should respond_with(:success) }
      it { response.body.should be_json_eql(json) }
    end

    context "when format is js" do
      before { get :index, :format => :js, :callback => :mycallback }
      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
      it { response.body.should match /^mycallback\(.*\)$/ }
      it { response.body.slice(11..-1).chop.should be_json_eql(json) }
    end
  end
  
end

