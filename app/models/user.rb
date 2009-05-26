class User
  include DataMapper::Resource
  property :id, Serial
  property :openid_url, String, :nullable => false, :unique => true
  property :name, String, :nullable => false
end
