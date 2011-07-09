class ContentController < ApplicationController
  layout :set_layout
  before_filter :ensure_logged_in
  
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
    @content = get_content
  end
  
  def update
    @content = get_content
    if @content.update_attributes(params[:content])
      redirect_to content_path(@content)
    else
      render :action => :edit
    end
  end
  
  def show
    @content = get_content
  end
  
  def destroy
    @content = get_content
    @content.destroy
    redirect_to "/"
  end
  
  private
    def set_layout
      false if params[:action] == "new"
      "application"
    end
    
    def get_content
      Content.first(:conditions => {:slug => params[:id]})
    end
  
end
