class DashboardController < ApplicationController
  
  def index
    @recent_content = Content.order_by(:published_date => -1)
    @recent_published = Content.published.order_by(:published_date => -1)
    @upcoming_content = Content.upcoming.order_by(:published_date => 1)
  end
  
end
