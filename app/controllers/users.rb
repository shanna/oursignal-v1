class Users < Application
  # provides :xml, :yaml, :js
  before :ensure_authenticated

  def index
    # redirect url(:edit_user, session.user)
    render
  end

  def show
    @user  = session.user
    display @user
  end

  def edit
    @user = session.user.reload
    raise NotFound unless @user
    display @user
  end

  def update
    # TODO: ...
  end

  def destroy
    # TODO: ...
  end

  def login
    # if the user is logged in, then redirect them to their profile
    redirect url(:edit_user, session.user.id), :message => { :notice => 'You are now logged in' }
  end

  def logout
    session.abandon!
    redirect '/', :message => { :notice => 'You are not logged out' }
  end
end
