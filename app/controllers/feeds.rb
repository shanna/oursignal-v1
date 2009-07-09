class Feeds < Application
  only_provides :json
  before :ensure_authenticated

  def index
    display session.user.user_feeds
  end

  def show
    # Nothing for a single feed yet.
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
    user = session.user
    feed = user.feed(params[:url])
    raise NotFound unless feed

    feed.score = params[:score]
    user.save
    display feed
  end

  def destroy
    user = session.user
    feed = user.feed(params[:url])
    raise NotFound unless feed

    user.user_feeds.delete(feed)
    user.save
    display @success = true
  end
end
