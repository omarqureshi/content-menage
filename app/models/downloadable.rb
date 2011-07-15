class Downloadable
  include Mongoid::Document
  embedded_in :content, :inverse_of => :downloadables
  
  field :title,        :type => String
  field :description,  :type => String
  field :tag,          :type => String
  field :downloadable, :type => String

  mount_uploader :downloadable, DownloadableUploader
end
