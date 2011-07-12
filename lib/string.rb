class String
  
  def namespace_classify
    self.split("::").collect(&:classify).join("::")
  end
  
end