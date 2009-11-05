class Feeds < Application
  only_provides :json
  before :ensure_authenticated
  before :ensure_authorized
  after  :purge_user_feed, :exclude => [:index]

  def index
    display session.user.user_feeds.to_a
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
