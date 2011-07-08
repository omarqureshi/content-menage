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
      get :index
    end
    
    it "fetches recent published content" do
      Content.should_receive(:published).once
      get :index
    end
    
    it "fetches upcoming content" do
      Content.should_receive(:upcoming).once
      get :index
    end
    
    it "should render with the index template" do
      get :index
      response.should render_template("index")
    end
    
  end

end
