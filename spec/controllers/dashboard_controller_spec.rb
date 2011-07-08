require 'spec_helper'

describe DashboardController do
  
  describe "GET index" do
    let(:content) { [mock_model(Content)] }
    before do
      [:recent, :published, :upcoming].each {|classification|
        Content.stub!(classification).and_return(content)
      }
      content.stub!(:limit).and_return(content)
    end
    
    it "fetches recent content" do
      Content.should_receive(:recent).once
      do_get
    end
    
    it "fetches recent published content" do
      Content.should_receive(:published).once
      do_get
    end
    
    it "fetches upcoming content" do
      Content.should_receive(:upcoming).once
      do_get
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render with the index template" do
      do_get
      response.should render_template("index")
    end
    
    def do_get(opts={})
      get :index, {}.merge(opts)
    end
    
  end

end
