Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  # Keep in mind the names are required by merb-auth-more.
  # TODO: merb-auth has a massive stink about it. Not as nice as the rest of Merb.
  match('/openid/login').to(:controller => :users, :action => 'login').name(:openid)
  match('/openid/signup').to(:controller => :open_id, :action => 'signup').name(:signup)

  match('/:username', :username => /^[a-z0-9\-\.]+$/) do
    # Almost RESTful but feeds don't have an :id.
    match('/feeds', :method => :get).to(:controller => :feeds, :action => :index)
    match('/feeds', :method => :post).to(:controller => :feeds, :action => :create)
    match('/feeds', :method => :put).to(:controller => :feeds, :action => :update)
    match('/feeds', :method => :delete).to(:controller => :feeds, :action => :destroy)

    match('/logout').to(:controller => :users, :action => 'logout').name(:logout)

    match('/').to(:controller => :users, :action => :index)
    match('/(:action)(.:format)').to(:controller => :users).name(:users)
  end

  match('/').to(:controller => :users, :action => 'index')
  # default_routes
end
