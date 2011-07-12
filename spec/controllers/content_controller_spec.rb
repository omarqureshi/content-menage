require 'spec_helper'

describe ContentController do
  
  describe 'GET new' do
    let(:user) { mock_model(User) }
    before do
      authentication_stub(user)
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render with the new template" do
      do_get
      response.should render_template("new")
    end
    
    def do_get
      get :new, {}, {:user_id => user.id}
    end
    
  end
  
  describe 'POST create' do
    let(:user) { mock_model(User) }
    let(:article) { mock_model(Article) }
    before do
      authentication_stub(user)
      Content.stub!(:new).and_return(article)
      article.stub!(:save).and_return(true)
    end
    
    it "should redirect" do
      do_post
      response.should be_redirect
    end
    
    it "should redirect to the edit page" do
      do_post
      response.should redirect_to(edit_content_path(article))
    end
    
    def do_post
      post :create, {:content => {:title => "Test article", :kind => "article", :publish_date => Date.today}}, {:user_id => user.id}
    end
    
  end
  
  describe 'GET edit' do
    let(:user) { mock_model(User) }
    let(:article) { mock_model(Article) }
    before do
      authentication_stub(user)
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render with the edit template" do
      do_get
      response.should render_template("edit")
    end
    
    def do_get
      get :edit, {:id => article.id}, {:user_id => user.id}
    end
    
  end
  
  describe 'POST update' do
    let(:user) { mock_model(User) }
    let(:article) { mock_model(Article) }
    before do
      authentication_stub(user)
      Content.stub!(:first).and_return(article)
      article.stub!(:update_attributes).and_return(true)
    end
    
    it "should redirect" do
      do_post
      response.should be_redirect
    end
    
    it "should redirect the content list page" do
      do_post
      response.should redirect_to(content_index_path)
    end
    
    def do_post
      post :update, {:id => article.id, :content => {:title => "Test article", :kind => "article", :publish_date => Date.today}}, {:user_id => user.id}
    end
  end
  
  describe 'GET index' do
    let(:user) { mock_model(User) }
    before do
      authentication_stub(user)
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should redirect to the index page" do
      do_get
      response.should render_template("index")
    end
    
    def do_get
      get :index, {}, {:user_id => user.id}
    end
  end

end
