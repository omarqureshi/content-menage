class DashboardController < ApplicationController
  
  def index
    @content_published_today = Content.all(:conditions => {:publish_date => Date.today})
  end
  
end
