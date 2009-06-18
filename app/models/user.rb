class User
  include Mongo::Resource

  def self.feed(user, url)
    user[:feeds].find{|feed| feed[:url] == url}
  end
end

