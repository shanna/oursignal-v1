class User < MongoRecord::Base
  collection_name :users
  fields :openid, :email, :fullname, :username, :feeds

  def password_required?; false end
end

