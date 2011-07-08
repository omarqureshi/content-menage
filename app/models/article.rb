class Article < Content
  field :body,          :type => String
  
  def self.text_area_fields
    super + [:body]
  end
  
  def self.order
    super + [:body]
  end
  
end