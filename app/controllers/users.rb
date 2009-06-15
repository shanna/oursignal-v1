class Users < Application
  before :ensure_authenticated, :exclude => :index

  def index
    provides :rss, :js
    # TODO: Feed for oursignal.
    render
  end

  def show
    provides :rss, :js
    # TODO: Feed for params[:nickname]
    render
  end

  def edit
    @user = session.user
    raise NotFound unless @user
    display @user
  end

  def login
    # if the user is logged in, then redirect them to their profile.
    redirect url(:edit_user, session.user.id), :message => { :notice => 'You are now logged in' }
  end

  def logout
    session.abandon!
    redirect '/', :message => { :notice => 'You are not logged out' }
  end
end
