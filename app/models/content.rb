class Content
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
    
  field :title,         :type => String
  field :slug,          :type => String
  field :publish_date,  :type => Time
  field :end_date,      :type => Time
  field :published,     :type => Boolean
  embeds_many :tags, :inverse_of => :content
  
  after_create :set_slug
  
  index(
    [
      [:publish_date, Mongo::DESCENDING],
      [:end_date, Mongo::ASCENDING ],
    ]
  )
  index "tags.title"
  index :slug, :unique => true
  
  validates_presence_of :title, :publish_date
  validate :valid_end_date
  
  attr_accessor :kind
  
  before_save :normalize_dates
  
  scope :published, lambda {
    any_of({:end_date.gt => Time.now.utc}, {:end_date => nil}).
    where(:published => true).
    where(:publish_date.lte => Time.now.utc).
    order_by(:published_date => -1)
  }
  
  scope :upcoming, lambda {
    where(:published => true).
    where(:publish_date.gte => Time.now.utc).
    order_by(:published_date => 1)
  }
  
  scope :recent, lambda {
    order_by(:published_date => -1)
  }
  
#  scope :with_namespace_prefix, lambda { |namespace|
#    regexp = RegExp.new("/^#{namespace.namespace_capitalize}") # gsub : for \:?
#    where(:type)
#  }

  scope :with_namespace, lambda { |namespace|
    where(:type => namespace.namespace_capitalize)
  }

  
  def self.new(*args)
    if self == Content
      this = super
      this = this.kind.namespace_capitalize.constantize.send(:new, *args) if this.kind
      this
    else
      super
    end
  end
  
  def fields_for_display
    @viewable_fields ||= (fields.reject {|k, v| k.starts_with?('_') || %w(version created_at updated_at slug).include?(k) || k.ends_with?("_ids")}).
                         sort {|a, b| (self.class.order.rindex(a[0].to_sym) || -1) <=> (self.class.order.rindex(b[0].to_sym) || -1)}
  end

  def self.text_area_fields
    []
  end
  
  def self.children(klass=self)
    return [] if klass.subclasses.nil?
    all_subclasses = []
    klass.subclasses.each do |klasz|
      all_subclasses << klasz
      all_subclasses += children(klasz)
    end
    all_subclasses
  end
  
  def self.order
    [:published_date, :end_date, :published, :title]
  end
  
  def set_slug
    self.slug = "#{id}-#{title.to_url}"
    save
  end
  
  def to_param
    slug
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
