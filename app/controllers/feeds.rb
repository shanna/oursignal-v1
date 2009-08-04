class Feeds < Application
  only_provides :json
  before :ensure_authenticated
  before :ensure_authorized

  def index
    sql = %q{
      select
        user_feeds.score,
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
    begin
      link = Link.discover(params[:url])
    rescue MongoMapper::DocumentNotValid => e
      raise BadRequest, e.message
    end

    unless feed = user.feed(link.url)
      user.user_feeds << feed = UserFeed.new(:url => link.url, :score => 0.5)
      user.save
    end

    display feed
  end

  def update
    user      = session.user
    user_feed = user.user_feeds.first(:feed_id => params[:feed_id])
    raise NotFound unless user_feed

    user_feed.score = params[:score]
    user_feed.save
    display user_feed
  end

  def destroy
    user      = session.user
    user_feed = user.user_feeds.first(:feed_id => params[:feed_id])
    raise NotFound unless user_feed
    display user_feed.destroy
  end
end
