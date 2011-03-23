class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_presence_of :title
  field :title,       :type => String
  references_and_referenced_in_many :content, :inverse_of => :tags
end
