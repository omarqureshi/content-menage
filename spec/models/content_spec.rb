require 'spec_helper'

describe Content do
  it { should validate_presence_of :title }
  it { should validate_presence_of :publish_date }
  it { should reference_many_and_be_referenced_in :tags }
  
  it "should allow blank end dates" do
    @content = Factory.build(:content, :end_date => nil)
    @content.should be_valid
  end
  
  it "should allow end dates greater than the publish date" do
    @content = Factory.build(:content, :publish_date => 1.month.ago.to_date, :end_date => Date.today)
    @content.should be_valid
  end
  
  it "should not allow end dates before the publish date" do
    @content = Factory.build(:content, :end_date => 1.month.ago.to_date, :publish_date => Date.today)
    @content.should_not be_valid
  end
  
  it "should pick up content published today and not ended" do
    @content = Factory(:content, :publish_date => Date.today)
    Content.published.first.should eq(@content)
  end
  
  it "should pick up content published a week ago and not ended" do
    @content = Factory(:content, :publish_date => 1.week.ago.to_date)
    Content.published.first.should eq(@content)
  end
  
  it "should pick up content published a week ago and not ending tomorrow" do
    @content = Factory(:content, :publish_date => 1.week.ago.to_date, :end_date => 1.day.from_now.to_date)
    Content.published.first.should eq(@content)
  end
  
  it "should not pick up content which is due to be published tomorrow" do
    @content = Factory(:content, :publish_date => 1.day.from_now.to_date)
    Content.published.first.should_not eq(@content)
  end
  
  it "should not pick up content which has ended today" do
    @content = Factory(:content, :publish_date => 1.week.ago.to_date, :end_date => Date.today)
    Content.published.first.should_not eq(@content)
  end
  
  it "should be able to create an Article when told to do so" do
    @content = Content.new(:publish_date => 1.week.ago.to_date, :kind => "article")
    assert @content.should be_a_kind_of(Article)
  end
  
  it "should not create an article by default" do
    @content = Content.new(:publish_date => 1.week.ago.to_date)
    assert @content.should be_a_kind_of(Content)
  end
end
