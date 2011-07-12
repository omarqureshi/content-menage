require 'spec_helper'

describe SessionController do

  describe "GET new" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should render with the new template" do
      get :new
      response.should render_template("new")
    end
    
  end
  
  describe "POST create" do
    context "given correct authentication parameters" do
      let(:user) { mock_model(User) }
      before do
        authentication_stub(user)
      end
      
      it "should redirect" do
        do_post
        response.should be_redirect
      end

      it "should redirect to the content list if no return_to is specified" do
        do_post
        response.should redirect_to(content_index_path)
      end

      it "should redirect to a return_to location if a return_to location is specified" do
        do_post(:return_to => "/foo")
        response.should redirect_to("/foo")
      end
      
      def do_post(opts={})
        post :create, {:email => "test@email.com", :password => "password"}.merge(opts)
      end
    end
    
    context "given incorrect authentication parameters" do
      it "should not redirect" do
        do_post
        response.should be_success
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("new")
      end
      
      def do_post(opts={})
        post :create, {:email => "test@email.com", :password => "password"}.merge(opts)
      end
      
    end
  end

end
