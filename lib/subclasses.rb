class Object
  def self.inherited(subclass)
    if @subclasses
      @subclasses << subclass
    else
      @subclasses = [subclass]
    end
  end

  def self.subclasses
    @subclasses
  end
end