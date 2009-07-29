require 'recaptcha'

class Users < Application
  before :ensure_authenticated, :exclude => [:index, :new, :create]
  before :ensure_authorized,    :exclude => [:index, :new, :create, :login]

  def index
    provides :rss, :json
    display user.links
  end

  def new
    display @user = User.new
  end

  def create
    # TODO: This could be part of validations on User.new.new?
    @captcha = Recaptcha.new('6Lc1hwcAAAAAADJWrrR3EeMFrI-NLYbw7x7F1S0w').verify(
      request.remote_ip,
      params[:recaptcha_challenge_field],
      params[:recaptcha_response_field]
    )

    @user            = User.new(params[:user])
    @user.user_feeds = user.user_feeds # oursignal feeds by default.
    if @user.save && @captcha.success
      session.user = @user
      redirect url(:users, @user.username)
    else
      render :new, :status => 422, :message => {:error => 'There was an error creating your user account'}
    end
  end

  def edit
    @user = session.user
    raise NotFound unless @user
    display @user
  end

  def login
    redirect url(:users, user.username) if session.user
  end

  def logout
    session.abandon!
    redirect '/', :message => { :notice => 'You are now logged out' }
  end
end
