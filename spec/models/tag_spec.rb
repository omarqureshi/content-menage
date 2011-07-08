require 'spec_helper'

describe Tag do
  it { should validate_presence_of :title }
  it { should be_embedded_in :content }
  
  context "for pre-defined articles and tags" do
    before(:each) do
      @rails_tag = {:title => "rails"}
      @pg_tag = {:title => "postgresql"}
      @ruby_tag = {:title => "ruby"}
      
      @pg_article = Factory(:article, :title => "PostgreSQL performance")
      @ts2_article = Factory(:article, :title => "Tsearch2 Rails applications")
      @rails_article = Factory(:article, :title => "Rails and Ruby tips")
      
      @pg_article.tags.create(@pg_tag)
      @ts2_article.tags.create(@pg_tag)
      @ts2_article.tags.create(@rails_tag)
      @rails_article.tags.create(@rails_tag)
      @rails_article.tags.create(@ruby_tag)
    end
    
    it "should be able to see all tags for postgresql article" do
      @pg_article.tags.collect(&:title).should include("postgresql")
    end

    it "should be able to see all tags for rails article" do
      @ts2_article.tags.collect(&:title).should include("postgresql")
      @ts2_article.tags.collect(&:title).should include("rails")
    end

    
    it "should be able to see all tags for rails article" do
      @rails_article.tags.collect(&:title).should include("ruby")
      @rails_article.tags.collect(&:title).should include("rails")
    end
    
  end
end
