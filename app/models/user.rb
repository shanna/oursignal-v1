class User
  include DataMapper::Resource
  property :id, Serial
  property :openid_url, URI, :nullable => false, :unique => true
  property :name, String, :nullable => false
end
