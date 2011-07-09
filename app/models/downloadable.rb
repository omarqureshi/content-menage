class Downloadable
  include Mongoid::Document
  embedded_in :content, :inverse_of => :downloadables
end
