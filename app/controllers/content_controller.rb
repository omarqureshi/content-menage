class ContentController < ApplicationController
  layout :set_layout
  
  def new
    @content = Content.new
    if request.xhr?
      render :layout => nil
    end
  end
  
  def create
    @content = Content.new(params[:content])
    if @content.save
      redirect_to edit_content_path(@content)
    else

    end
  end

  def edit
    @content = Content.find(params[:id])
  end
  
  private
    def set_layout
      false if params[:action] == "new"
      "application"
    end
  
end
