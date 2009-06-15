class User < MongoRecord::Base
  collection_name :users
  fields :openid, :email, :fullname, :username, :feeds

  def feeds
    @feeds = [] if @feeds.nil? || @feeds.empty?
    @feeds
  end

  def feed(url)
    feeds.find{|feed| feed['url'] = url}
  end

  def password_required?; false end
end

