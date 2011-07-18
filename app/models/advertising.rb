module Advertising
  extend ActiveSupport::Concern
  
  included do
    field :feature_box_link, :type => String
  end
  
  module ClassMethods
  
    def downloadable_tags
      super + %w(FeatureBox)
    end
    
    def order
      super + [:feature_box_link]
    end
    
  end
  
  module InstanceMethods
  end
  
end