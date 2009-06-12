class User < MongoRecord::Base
  collection_name :users
  fields :identity_url, :username, :email

  def password_required?; false end
end

