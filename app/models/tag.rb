class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_presence_of :title
  field :title,       :type => String
  embedded_in :content, :inverse_of => :tags
end
