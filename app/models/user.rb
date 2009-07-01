class UserFeed
  include MongoMapper::EmbeddedDocument
  key :url,   String
  key :score, Float
  # key :link,  ::Link
end

class User
  include MongoMapper::Document
  key :username, String
  key :fullname, String
  key :email,    String
  key :openid,   String
  many :user_feeds

  def feed(url)
    user_feeds.find{|feed| feed.url == url}
  end
end

