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

  def links(limit = 50)
    results   = {}
    referrers = user_feeds.map{|feed| [feed.url, feed.score]}.to_hash

    # Find.
    Link.all(
      :conditions => {:referrers => referrers.keys, :feed => {}},
      :order      => 'score desc, created_at asc'
    ).each do |link|
      link.score.score = referrers.values_at(*link.referrers).compact.first * link.score.score
      results[link.url] = link.freeze # Make uniq by URL.
    end

    # Sort & Limit
    results = results.values.sort{|a, b| b.score.score <=> a.score.score}
    results = results.slice(0, limit)
  end

  def feed(url)
    user_feeds.find{|feed| feed.url == url}
  end
end

