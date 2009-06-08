Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  resources :users
  resources :feeds
  resources :themes # TODO: Not a RESTful resource.

  # Keep in mind the names are required by merb-auth-more.
  # TODO: merb-auth has a massive stink about it. Not as nice as the rest of Merb.
  match('/openid/login').to(:controller => :users, :action => 'login').name(:openid)
  match('/openid/logout').to(:controller => :users, :action => 'logout').name(:logout)
  match('/openid/signup').to(:controller => :open_id, :action => 'signup').name(:signup)


  match('/').to(:controller => :themes, :action => 'index')
end
