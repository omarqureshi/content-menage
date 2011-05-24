class Content
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
  field :title,         :type => String
  field :publish_date,  :type => Time
  field :end_date,      :type => Time
  field :published,     :type => Boolean
  references_and_referenced_in_many :tags, :inverse_of => :content
  
  index(
    [
      [:publish_date, Mongo::DESCENDING],
      [:end_date, Mongo::ASCENDING ],
    ]
  )

  validates_presence_of :title, :publish_date
  validate :valid_end_date
  
  attr_accessor :kind
  
  before_save :normalize_dates
  
  scope :published, lambda {
    any_of({:end_date.gt => Time.now.utc}, {:end_date => nil}).
    where(:published => true).
    where(:publish_date.lte => Time.now.utc)
  }
  
  scope :upcoming, lambda {
    where(:published => true).
    where(:publish_date.gte => Time.now.utc)
  }
  
  def self.new(*args)
    if self == Content
      this = super
      this = this.kind.capitalize.constantize.send(:new, *args) if this.kind
      this
    else
      super
    end
  end

  def viewable_fields
    @viewable_fields ||= fields.reject {|k, v| k.starts_with?('_') || %w(version created_at updated_at).include?(k) || k.ends_with?("_ids")}
  end
  
  private
  
    def normalize_dates
      convert_date(publish_date)
      convert_date(end_date)
    end
  
    def convert_date(date)
      date.to_time.utc.beginning_of_day if date.kind_of?(Date)
    end
  
    def valid_end_date
      errors.add(:end_date, "should be before the publish date") unless (end_date.nil? || publish_date < end_date)
    end
end
