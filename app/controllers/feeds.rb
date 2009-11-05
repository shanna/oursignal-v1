class Feeds < Application
  only_provides :json
  before :ensure_authenticated
  before :ensure_authorized
  after  :purge_user_feed, :exclude => [:index]

  def index
    links      = session.user.links.to_a
    user_feeds = session.user.user_feeds.map do |uf|
      count = links.find_all{|l| l.referrers.keys.include?(uf.feed.domain)}.size
      {
        :user_id => uf.user_id,
        :feed_id => uf.feed_id,
        :score   => uf.score,
        :title   => uf.feed.title,
        :url     => uf.feed.url,
        :domain  => uf.feed.domain,
        :ratio   => ((count.to_f / links.size) * 100).to_i
      }
    end
    display user_feeds
  end

  def create
    user = session.user
    feed = Feed.discover(params[:url])
    raise(BadRequest, feed.errors.full_messages.join(', ')) unless feed.valid?(:discover)
    raise(BadRequest, 'Already in your feeds') if user.feeds.include?(feed)

    display user.user_feeds.first_or_create({:feed => feed}, :score => 0.5)
  end

  def update
    user      = session.user
    user_feed = user.user_feeds.first(:feed_id => params[:id])
    raise NotFound unless user_feed

    user_feed.update(params.only(:score))
    display user_feed
  end

  def destroy
    user      = session.user
    user_feed = user.user_feeds.first(:feed_id => params[:id])
    raise NotFound unless user_feed
    display user_feed.destroy
  end
end
