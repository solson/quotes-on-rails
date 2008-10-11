ActionController::Routing::Routes.draw do |map|
  # Restful Authentication Rewrites
  map.latest '/latest', :controller => 'quotes', :action => 'latest'
  map.browse '/browse', :controller => 'quotes', :action => 'browse'
  map.random '/random', :controller => 'quotes', :action => 'random'
  map.top '/top', :controller => 'quotes', :action => 'top'
  map.bottom '/bottom', :controller => 'quotes', :action => 'bottom'
  map.queue '/queue', :controller => 'quotes', :action => 'queue'
  map.add '/add', :controller => 'quotes', :action => 'new'
  map.search '/search', :controller => 'quotes', :action => 'search'
  map.short_quote '/:id', :controller => 'quotes', :action => 'show', :id => /\d+/
  
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  
  # Restful Authentication Resources
  map.resources :quotes
  map.resources :users
  map.resources :passwords
  map.resource :session
  
  # Home Page
  map.root :controller => 'quotes', :action => 'index'

#  # Install the default routes as the lowest priority.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
