class Feeds < Application
  only_provides :json
  before :ensure_authenticated

  def index
    display session.user.feeds
  end

  def show
    # Nothing for a single feed yet.
  end

  def create
    user = session.user

    # TODO: Feed url normalization.
    # TODO: Check feed exists with columbus.
    # if feed = Feed.find_or_create_by_url(
    #   params.only(:url),
    #   params.only(:url)
    # )
    #   feed.selfupdate
    # end

    unless feed = user.feed(params[:url])
      user.feeds << feed = params.only(:url).update(:score => 50).to_mash
      $stderr.puts user.inspect
      user.save
    end

    display feed
  end

  def update
    user = session.user
    feed = user.feed(params[:url])
    raise NotFound unless feed

    feed.update(params.only(:score).to_mash)
    user.save
    display @feed
  end

  def destroy
    user = session.user
    feed = user.feed(params[:url])
    raise NotFound unless feed

    user.feeds.delete(feed)
    user.save
    display @success = true
  end
end
