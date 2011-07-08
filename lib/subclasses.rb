class Object
  def self.inherited(subclass)
    if @subclasses
      @subclasses << subclass unless @subclasses.include?(subclass)
    else
      @subclasses = [subclass]
    end
  end

  def self.subclasses
    @subclasses
  end
end