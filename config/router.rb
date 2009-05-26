Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  default_routes

  # Change this for your home page to be available at /
  # match('/').to(:controller => 'whatever', :action =>'index')
end
