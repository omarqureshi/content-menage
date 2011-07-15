class DownloadablesController < ApplicationController
  before_filter :ensure_logged_in
  
  def update
    @content = get_content
    @downloadable = get_downloadable
    @downloadable.attributes = params[:downlodable]
    @downloadable.save
    redirect_to edit_content_path(@content)
  end
  
  private
  
    def get_content
      Content.first(:conditions => {:slug => params[:content_id]})
    end
    
    def get_downloadable
      if @content
        @content.downloadables.first || @content.downloadables.build
      end
    end
  
end
