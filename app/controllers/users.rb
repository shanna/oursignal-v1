class Users < Application
  before :ensure_authenticated, :exclude => [:index, :new, :create]
  before :ensure_authorized,    :exclude => [:index, :new, :create, :login]

  def index
    provides :rss, :js
    render
  end

  def new
    display @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session.user = @user
      redirect url(:users, @user.username)
    else
      message[:error] = 'There was an error creating your user account'
      render :new, :status => 422
    end
  end

  def edit
    @user = session.user
    raise NotFound unless @user
    display @user
  end

  def login
    redirect url(:users, session.user.username) if session.user
  end

  def logout
    session.abandon!
    redirect '/', :message => { :notice => 'You are now logged out' }
  end
end
