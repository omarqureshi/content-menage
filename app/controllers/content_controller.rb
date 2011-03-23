class ContentController < ApplicationController
  layout :set_layout
  
  def new
    @content = Content.new
  end
  
  def create
    @content = Content.new(params[:content])
    if @content.save
      redirect_to edit_content_path
    else
      logger.error @content.inspect
      logger.error @content.errors.inspect
    end
  end
  
  private
    def set_layout
      false if params[:action] == "new"
    end
  
end
