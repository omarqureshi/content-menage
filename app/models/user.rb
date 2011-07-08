class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :email,           :type => String
  field :full_name,       :type => String
  field :password_digest, :type => String

  has_secure_password
  validates :password, :presence => { :on => :create }
  
  validates_presence_of :email
  validates_presence_of :full_name
  validates_uniqueness_of :email, :case_sensitive => false
  
  scope :with_email, lambda {|x| where(:email => x.downcase).limit(1) }
end
