Merb.logger.info("Compiling routes...")
Merb::Router.prepare do

  # TODO: Yick. Can we get Rabbits to do this with disstill?
  match('/rss/digg.rss').to(:controller => :rss, :action => 'digg')

  # TODO: Rename public?
  match('/static/:path_as_page').to(:controller => :static, :action => 'show')

  match('/signup', :method => :get).to(:controller => :users, :action => 'new').name(:signup)
  match('/signup', :method => :post).to(:controller => :users, :action => 'create')
  match('/login').to(:controller => :users, :action => 'login').name(:openid).name(:login)

  resources :users, :key => :username, :identify => :username do
    resources :feeds
    match('/logout').to(:controller => :users, :action => 'logout').name(:logout)
  end

  match('/:username(.:format)', :username => /^[a-z0-9][a-z0-9\-]+$/i, :method => :get) \
    .to(:controller => :users, :action => 'show') \
    .name(:links)
  match('/(.:format)', :method => :get) \
    .to(:controller => :users, :action => 'show', :username => 'oursignal') \
    .name(:root)
end
