class Feeds < Application
  only_provides :json
  before :ensure_authenticated

  def index
    @feeds = UserFeed.all(:user => session.user)
    display @feeds
  end

  def show
  end

  def create
    feed       = Feed.first(params.only(:url)) || Feed.create!(params.only(:url))
    @user_feed = UserFeed.create(:user => session.user, :feed => feed)
    display @user_feed
  end

  def edit
  end

  def update
    # TODO: Undefined method target_model in UserFeed.
    # @user_feed = session.user.feeds.first(:feed_id => params[:id].to_i)
    if @user_feed = UserFeed.first(:user => session.user, :feed_id => params[:id].to_i)
      @user_feed.update(params.only(:score))
    end
    display @user_feed
  end
end
