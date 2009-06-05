class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :nullable => false
  property :email, String, :nullable => false, :unique => true
  property :identity_url, String, :nullable => false, :unique => true

  has n, :feeds, :through => UserFeed

  validates_format :email, :as => :email_address
  def password_required?; false end
end
