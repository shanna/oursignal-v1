require 'recaptcha'

class Users < Application
  before :ensure_authenticated, :exclude => [:index, :show, :new, :create]
  before :ensure_authorized,    :exclude => [:index, :show, :new, :create, :login]
  after  :purge_user_feed,      :only    => [:update]

  def index
    # TODO: This will be the scoreboard stuff later.
    redirect '/signup'
  end

  def show
    provides :rss, :xml, :json
    if !params[:username].blank? && params[:username] != user.username
      raise NotFound
    else
      display @links = user.links
    end
  end

  def new
    cookies.delete(:username)
    cookies.delete(:show_new_windo)
    display @user = User.new
  end

  def create
    # TODO: This could be part of validations on User.new.new?
    @captcha = Recaptcha.new('6Lc1hwcAAAAAADJWrrR3EeMFrI-NLYbw7x7F1S0w').verify(
      request.remote_ip,
      params[:recaptcha_challenge_field],
      params[:recaptcha_response_field]
    )

    @user = User.new(params[:user])
    if @user.valid? && @captcha.success && @user.save
      session.user              = @user
      cookies.set_cookie(:username, @user.username, :secure => false, :expires => Merb::Const::WEEK * 60)
      cookies.set_cookie(:show_new_window, @user.show_new_window, :secure => false, :expires => Merb::Const::WEEK * 60)
      redirect resource(@user), :message => {:success => 'Signup was successful', :notice => 'You are now logged in'}
    else
      render :new, :status => 422, :message => {:error => 'There was an error creating your user account'}
    end
  end

  def edit
    @user = session.user
    raise NotFound unless @user
    cookies.set_cookie(:username, @user.username, :secure => false, :expires => Time.now + Merb::Const::WEEK * 60)
    cookies.set_cookie(:show_new_window, @user.show_new_window, :secure => false, :expires => Time.now + Merb::Const::WEEK * 60)
    display @user
  end

  def update
    @user = session.user.dup
    raise NotFound unless @user

    # TODO: Must be a nicer way to do these.
    params[:user][:theme] = Theme.get(params[:user][:theme]) unless params[:user][:theme].blank?

    params[:user].delete(:password) if params[:user][:password].blank? # TODO: Build this into user?
    if @user.update(params[:user])
      cookies.set_cookie(:username, @user.username, :secure => false, :expires => Time.now + Merb::Const::WEEK * 60)
      cookies.set_cookie(:show_new_window, @user.show_new_window, :secure => false, :expires => Time.now + Merb::Const::WEEK * 60)
      redirect resource(@user, :edit), :message => {:notice => 'Your user account was updated'}
    else
      display @user, :edit, :status => 422, :message => {:error => 'There was an error updating your user account'}
    end
  end

  def login
    if session.user
      cookies.set_cookie(:username, user.username, :secure => false, :expires => Time.now + Merb::Const::WEEK * 60)
      cookies.set_cookie(:show_new_window, user.show_new_window, :secure => false, :expires => Time.now + Merb::Const::WEEK * 60)
      redirect resource(user, :edit)
    end
  end

  def logout
    session.abandon!
    cookies.delete(:username)
    cookies.delete(:show_new_window)
    redirect '/', :message => {:notice => 'You are now logged out'}
  end
end
