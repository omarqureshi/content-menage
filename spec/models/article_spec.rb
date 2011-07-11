require 'spec_helper'
require 'dummy/article'

describe Article do
  it { should validate_presence_of :title }
  it { should validate_presence_of :publish_date }
  it { should embed_many :tags }
  
  it "should be a subclass of content" do
    Content.subclasses.should include(Article)
  end
  
  it "should allow blank end dates" do
    @article = Factory.build(:article, :end_date => nil)
    @article.should be_valid
  end
  
  it "should allow end dates greater than the publish date" do
    @article = Factory.build(:article, :publish_date => 1.month.ago.utc.beginning_of_day, :end_date => Time.now.utc.beginning_of_day)
    @article.should be_valid
  end
  
  it "should not allow end dates before the publish date" do
    @article = Factory.build(:article, :end_date => 1.month.ago.utc.beginning_of_day, :publish_date => Time.now.utc.beginning_of_day)
    @article.should_not be_valid
  end
  
  it "should pick up article published today and not ended" do
    @article = Factory(:article, :publish_date => Time.now.utc.beginning_of_day)
    Article.published.first.should eq(@article)
  end
  
  it "should pick up article published a week ago and not ended" do
    @article = Factory(:article, :publish_date => 1.week.ago.utc.beginning_of_day)
    Article.published.first.should eq(@article)
  end
  
  it "should pick up article published a week ago and not ending tomorrow" do
    @article = Factory(:article, :publish_date => 1.week.ago.utc.beginning_of_day, :end_date => 1.day.from_now.utc.beginning_of_day)
    Article.published.first.should eq(@article)
  end
  
  it "should not pick up article which is due to be published tomorrow" do
    @article = Factory(:article, :publish_date => 1.day.from_now.utc.beginning_of_day)
    Article.published.first.should_not eq(@article)
  end
  
  it "should not pick up article which has ended today" do
    @article = Factory(:article, :publish_date => 1.week.ago.utc.beginning_of_day, :end_date => Time.now.utc.beginning_of_day)
    Article.published.first.should_not eq(@article)
  end
end