Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  match('/static/:path_as_page').to(:controller => :static, :action => 'show')

  match('/signup', :method => :get).to(:controller => :users, :action => 'new').name(:signup)
  match('/signup', :method => :post).to(:controller => :users, :action => 'create')
  match('/login').to(:controller => :users, :action => 'login').name(:openid).name(:login)

  match('/:username(.:format)', :username => /^[a-z0-9][a-z0-9\-]+$/i) do
    match('/feeds', :method => :get).to(:controller => :feeds, :action => 'index')
    match('/feeds', :method => :post).to(:controller => :feeds, :action => 'create')
    match('/feeds', :method => :put).to(:controller => :feeds, :action => 'update')
    match('/feeds', :method => :delete).to(:controller => :feeds, :action => 'destroy')

    match('/logout').to(:controller => :users, :action => 'logout').name(:logout)

    match('/(:action)').to(:controller => :users).name(:users)
    match('/(.:format)').to(:controller => :users, :action => 'show')
    match('(.:format)').to(:controller => :users, :action => 'show')
  end

  match('/(.:format)').to(:controller => :users, :action => 'index')
end
