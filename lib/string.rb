class String
  
  def namespace_capitalize
    self.split("::").collect(&:capitalize).join("::")
  end
  
end