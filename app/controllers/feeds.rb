class Feeds < Application
  only_provides :json
  before :ensure_authenticated
  before :ensure_authorized
  after  :purge_user_feed, :exclude => [:index]

  def index
    sql = %q{
      select
        user_feeds.score,
        user_feeds.follow,
        feeds.id as feed_id,
        feeds.title,
        feeds.url
      from feeds
      inner join user_feeds on feeds.id = user_feeds.feed_id
      where user_feeds.user_id = ?
    }
    display repository(:default).adapter.query(sql, session.user.id)
  end

  def create
    user = session.user
    feed = Feed.discover(params[:url])
    raise(BadRequest, feed.errors.full_messages.join(', ')) unless feed.valid?(:discover)

    user_feed = user.user_feeds.first_or_create({:feed => feed}, :score => 0.5)
    display({
      :user_id => user_feed.user_id,
      :feed_id => user_feed.feed_id,
      :score   => user_feed.score,
      :follow  => user_feed.follow,
      :title   => feed.title,
      :url     => feed.url
    })
  end

  def update
    user      = session.user
    user_feed = user.user_feeds.first(:feed_id => params[:id])
    raise NotFound unless user_feed

    user_feed.update(params.only(:score, :follow))
    display user_feed
  end

  def destroy
    user      = session.user
    user_feed = user.user_feeds.first(:feed_id => params[:id])
    raise NotFound unless user_feed
    display user_feed.destroy
  end
end
