class Content
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps
  field :title,         :type => String
  field :publish_date,  :type => Date
  field :end_date,      :type => Date
  field :published,     :type => Boolean
  references_and_referenced_in_many :tags, :inverse_of => :content
  
  validates_presence_of :title, :publish_date
  
  validate :valid_end_date
  
  attr_accessor :kind
  
  def self.new(*args)
    if self == Content
      this = super
      this = this.kind.capitalize.constantize.send(:new, *args) if this.kind
      this
    else
      super
    end
  end
  
  scope :published, lambda {
    today = Date.today
    js_date = "new Date(#{today.year}, #{today.month - 1}, #{today.day})"
    where("function() {return this.published && (this.end_date == null || this.end_date > #{js_date}) && this.publish_date <= #{js_date}}")
  }
  
  private
  
    def valid_end_date
      errors.add(:end_date, "should be before the publish date") unless (end_date.nil? || publish_date < end_date)
    end
end
