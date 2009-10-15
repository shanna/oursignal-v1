migration 3, :feeds do
  # The skinny is the more sites the better.
  feeds = %w{
    http://rss.slashdot.org/Slashdot/slashdot
    http://feeds2.feedburner.com/Rubyflow
    http://www.rubyinside.com/feed
    http://feeds.feedburner.com/TechCrunch
    http://feeds.huffingtonpost.com/huffingtonpost/LatestNews
    http://feeds.feedburner.com/github
    http://feeds.theonion.com/theonion/daily
    http://happypenguin.org/html/news.rdf
    http://feeds.feedburner.com/TheThrillingWonderStory
    http://gizmodo.com/tag/top/index.xml
    http://www.engadget.com/rss.xml
    http://feeds.boingboing.net/boingboing/iBag
    http://feeds2.feedburner.com/Mashable
    http://googleblog.blogspot.com/atom.xml
    http://www.readwriteweb.com
    http://newsbusters.org
    http://www.kotaku.com
    http://blogs.telegraph.co.uk/news
    http://www.joystiq.com
    http://lifehacker.com
    http://www.gawker.com
    http://consumerist.com
    http://crunchgear.com
    http://www.deadspin.com
    http://www.neatorama.com
    http://appleinsider.com
  }

  up do
    feeds.each{|url| Feed.discover(url)}
  end

  down do
    feeds.each{|url| Feed.discover(url).destroy rescue nil}
  end
end
