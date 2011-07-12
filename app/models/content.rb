class Content
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
  
  MIN_PRIORITY = 1
  MAX_PRIORITY = 100
  DEFAULT_PRIORITY = 50
  
  field :title,         :type => String
  field :slug,          :type => String
  field :publish_date,  :type => Time
  field :end_date,      :type => Time
  field :published,     :type => Boolean
  field :priority,      :type => Integer
  belongs_to :user
  embeds_many :tags, :inverse_of => :content
  embeds_many :downloadables, :inverse_of => :content
  
  validates_numericality_of :priority, :only_integer => true, 
                                       :greater_than_or_equal_to => MIN_PRIORITY,
                                       :less_than_or_equal_to => MAX_PRIORITY,
                                       :allow_nil => true
  
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
    where(:publish_date.lte => Time.now.utc)
  }
  
  scope :upcoming, lambda {
    where(:published => true).
    where(:publish_date.gte => Time.now.utc).
    order_by(:publish_date => 1)
  }
  
  scope :recent, lambda {
    order_by(:publish_date => -1)
  }
  
  scope :of_type, lambda { |type|
    where(:_type => type.namespace_classify)
  }
  
  scope :by_user_id, lambda { |user_id|
    where(:user_id => user_id)
  }
  
#  scope :with_namespace_prefix, lambda { |namespace|
#    regexp = RegExp.new("/^#{namespace.namespace_capitalize}") # gsub : for \:?
#    where(:type)
#  }

# scope :with_namespace, lambda { |namespace|
#   where(:_type => namespace.namespace_classify)
# }

  
  def self.new(*args)
    if self == Content
      this = super
      this = this.kind.namespace_classify.constantize.send(:new, *args) if this.kind
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
  
  def self.downloadable_tags
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
    [:publish_date, :end_date, :published, :title]
  end
  
  def set_slug
    self.slug = "#{id}-#{title.to_url}"
    save
  end
  
  def to_param
    slug
  end
  
  def status
    now = Time.now.utc
    if now >= publish_date
      if end_date.nil? || now <= end_date
        if published
          return "Published"
        else
          return "Pending Approval"
        end
      else
        if published
          return "Expired"
        else
          return "Expired and Pending"
        end
      end
    else
      if published
        "Queued"
      else
        "Queued and Pending"
      end
    end
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
