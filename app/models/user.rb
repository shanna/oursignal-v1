class User
  include MongoMapper::Document
  key :username, String
  key :fullname, String
  key :email,    String
  key :openid,   String
  many :feeds

  def feed(url)
    feeds.find{|feed| feed[:url] == url}
  end
end

