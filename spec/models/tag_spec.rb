require 'spec_helper'

describe Tag do
  it { should validate_presence_of :title }
  it { should reference_many_and_be_referenced_in :content }
  
  context "for pre-defined articles and tags" do
    before(:each) do
      @rails_tag = Factory(:tag, :title => "rails")
      @pg_tag = Factory(:tag, :title => "postgresql")
      @ruby_tag = Factory(:tag, :title => "ruby")
      
      @pg_article = Factory(:article, :title => "PostgreSQL performance")
      @ts2_article = Factory(:article, :title => "Tsearch2 Rails applications")
      @rails_article = Factory(:article, :title => "Rails and Ruby tips")
      
      @pg_article.tags << @pg_tag
      @ts2_article.tags << @pg_tag
      @ts2_article.tags << @rails_tag
      @rails_article.tags << @rails_tag
      @rails_article.tags << @ruby_tag
    end
    
    it "should be able to see all postgresql articles" do
      @pg_tag.content.should include(@pg_article)
      @pg_tag.content[0].should be_a_kind_of(Article)
    end
    
    it "should be able to see all rails articles" do
      @rails_tag.content.should include(@ts2_article)
      @rails_tag.content.should include(@rails_article)
      @rails_tag.content[0].should be_a_kind_of(Article)
      @rails_tag.content[1].should be_a_kind_of(Article)
    end

    it "should be able to see all ruby articles" do
      @ruby_tag.content.should include(@rails_article)
      @ruby_tag.content[0].should be_a_kind_of(Article)
    end
    
    it "should be able to see all tags for postgresql article" do
      @pg_article.tags.should include(@pg_tag)
    end

    it "should be able to see all tags for rails article" do
      @ts2_article.tags.should include(@pg_tag)
      @ts2_article.tags.should include(@rails_tag)
    end

    
    it "should be able to see all tags for rails article" do
      @rails_article.tags.should include(@ruby_tag)
      @rails_article.tags.should include(@rails_tag)
    end
    
  end
end
