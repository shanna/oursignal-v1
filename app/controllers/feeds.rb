class Feeds < Application
  only_provides :json
  before :ensure_authenticated

  def index
    display session.user[:feeds] || []
  end

  def show
    # Nothing for a single feed yet.
  end

  def create
    user = session.user
    feed = Feed.repsert(params.only(:url).to_mongo, params.only(:url).to_mongo)

    # users.feeds
    unless user_feed = User.feed(user, params[:url])
      # TODO: I'm sure there is an easy way to repsert to a subobject.
      user[:feeds] << user_feed = params.only(:url).update(:score => 50, :feed => feed.to_mongo(:feed)).to_mongo
      User.save(user.to_mongo)
    end

    display user_feed
  end

  def update
    user = session.user
    feed = User.feed(user, params[:url])
    raise NotFound unless feed

    feed[:score] = params[:score]
    User.save(user)
    display feed
  end

  def destroy
    user = session.user
    feed = User.feed(user, params[:url])
    raise NotFound unless feed

    user[:feeds].delete(feed)
    User.save(user)
    display @success = true
  end
end
