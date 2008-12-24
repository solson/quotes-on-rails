ActionController::Routing::Routes.draw do |map|
  # Restful Authentication Rewrites
  map.latest '/latest', :controller => 'quotes', :action => 'latest'
  map.browse '/browse', :controller => 'quotes', :action => 'browse'
  map.random '/random', :controller => 'quotes', :action => 'random'
  map.top    '/top',    :controller => 'quotes', :action => 'top'
  map.bottom '/bottom', :controller => 'quotes', :action => 'bottom'
  map.queue  '/queue',  :controller => 'quotes', :action => 'queue'
  map.add    '/add',    :controller => 'quotes', :action => 'new'
  map.search '/search', :controller => 'quotes', :action => 'search'
  map.rss    '/rss',    :controller => 'quotes', :action => 'rss'
  map.short_quote '/:id', :controller => 'quotes', :action => 'show', :id => /\d+/
  
  map.vote '/quotes/:id/vote/:up_or_down', :controller => 'quotes',
                 :action => 'vote', :id => /\d+/, :up_or_down => /(up|down)/
  
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  
  # Restful Authentication Resources
  map.resources :quotes
  map.resources :passwords
  map.resources :admins
  map.resource :session
  
  # Home Page
  map.root :controller => 'quotes', :action => 'index'

#  # Install the default routes as the lowest priority.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
