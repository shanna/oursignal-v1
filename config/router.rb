Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  resources :users
  resources :themes

  # Keep in mind the names are required by merb-auth-more.
  match('/openid/login').to(:controller => :users, :action => 'login').name(:openid)
  match('/openid/logout').to(:controller => :users, :action => 'logout').name(:logout)
  match('/openid/signup').to(:controller => :open_id, :action => 'signup').name(:signup)

  # Change this for your home page to be available at /
  match('/').to(:controller => :themes, :action => 'index')
end
