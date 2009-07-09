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
    Link.all(:conditions => {:referrers => referrers.keys, :feed => {}}).each do |link|
      # TODO: Next on links without a score later.
      link.score = link.referrers.find{|r| referrers[r]} * (link.score || 0)
      results[link.url] = link # Make uniq by URL.
    end

    # Sort & Limit
    results = results.values.sort{|a, b| a.score <=> b.score}
    results.slice(0, limit)
  end

  def feed(url)
    user_feeds.find{|feed| feed.url == url}
  end
end

