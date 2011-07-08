class DashboardController < ApplicationController
  
  def index
    @recent_content = Content.recent.limit(10)
    @recent_published = Content.published.limit(10)
    @upcoming_content = Content.upcoming.limit(10)
  end
  
end
