class Passwords < Application
  def new
    render
  end

  def create
    if @user = User.first(:username => params[:username])
      # TODO: Move to ::User?
      @user.update(:password_reset => Digest::SHA1.hexdigest('some salt' + @user.username + DateTime.now.to_s))

      send_mail(
        PasswordsMailer,
        :create,
        {:from => 'no-reply@oursignal.com', :to => @user.email, :subject => 'Oursignal password recovery.'},
        {:user => @user}
      )
      display @user
    else
      message[:error] = "Username '#{h(params[:username])}' doesn't exist."
      render :new
    end
  end

  def edit
    @user = User.first(:password_reset => params[:recover])
    raise NotFound unless @user
    display @user
  end

  def update
    @user = User.first(:password_reset => params[:user][:password_reset])
    raise NotFound unless @user
    if @user.update(:password => params[:user][:password])
      session.user = @user
      cookies.set_cookie(:username, @user.username, :secure => false, :expires => Time.now + Merb::Const::WEEK * 60)
      redirect resource(@user), :message => {:success => 'Password changed.', :notice => 'You are now logged in'}
    else
      display @user, :edit, :status => 422, :message => {:error => 'There was an error updating your user account'}
    end
  end
end
