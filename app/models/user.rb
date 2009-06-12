class User < MongoRecord::Base
  collection_name :users
  fields :identity_url, :username, :email
  index :identity_url

  def password_required?; false end
end

