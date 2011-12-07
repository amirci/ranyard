shared_examples_for "resource single read" do
  describe "#show" do
    context 'when format is html' do
      before { get :show, :id => resource.id }

      it { should assign_to(symbol).with(resource) }
      it { should respond_with_content_type(:html) }
      it { should render_template(:show) }
    end

    context "when format is json" do
      before { get :show, :format => :json,:id => resource.id }
      it { should respond_with_content_type(:json) }
      it { should respond_with(:success) }
      it { response.body.should eq(json) }
    end

    context "when format is js" do
      before { get :show, :format => :js, :id => resource.id, :callback => :mycallback }
      it { should respond_with_content_type(:js) }
      it { should respond_with(:success) }
      it { response.body.should eq("mycallback(#{json})") }
    end
  end
end