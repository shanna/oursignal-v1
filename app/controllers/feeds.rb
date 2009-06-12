class Feeds < Application
  only_provides :json
  before :ensure_authenticated

  def index
    user  = session.user
    feeds = user.feeds || user.feeds = [] # TODO: Defaults in User.
    user.save
    $stderr.puts feeds.inspect
    display feeds
  end

  def show
  end

  def create
    # TODO: Feed url normalization.
    # TODO: Check feed exists with columbus.
    # if feed = Feed.find_or_create_by_url(
    #   params.only(:url),
    #   params.only(:url)
    # )
    #   feed.selfupdate
    # end

    # TODO: Build this into User.
    user  = session.user
    feeds = user.feeds || user.feeds = [] # TODO: Defaults in User.
    unless feeds.find{|feed| feed[:url] == params[:url]}
      feeds << feed = params.only(:url).update(:score => 50)
      user.save
    end

    display feed
  end

  def update
    if @user_feed = UserFeed.first(:user => session.user, :feed_id => params[:id].to_i)
      @user_feed.update(params.only(:score))
    end
    display @user_feed
  end

  def destroy
    if @user_feed = UserFeed.first(:user => session.user, :feed_id => params[:id].to_i)
      @user_feed.destroy
    end
    display @success = true
  end
end
