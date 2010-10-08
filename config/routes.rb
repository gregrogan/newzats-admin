ActionController::Routing::Routes.draw do |map|

map.root :controller => "member", :action => 'list'

map.connect 'member/email', :controller => 'member', :action => 'email'
map.connect 'member/list', :controller => 'member', :action => 'list'
map.connect 'member/search', :controller => 'member', :action => 'search'
map.connect 'member/new', :controller => 'member', :action => 'new'
map.connect 'member/create', :controller => 'member', :action => 'create'
map.connect 'member/show/:id', :controller => 'member', :action => 'show'
map.connect 'member/show/:id/notes', :controller => 'member', :action => 'notes'
map.connect 'member/create/:id/note', :controller => 'member', :action => 'create_note'
map.connect 'member/edit/:id', :controller => 'member', :action => 'edit'
map.connect 'member/update/:id', :controller => 'member', :action => 'update'
map.connect 'member/delete/:id', :controller => 'member', :action => 'delete'

map.connect 'group/list', :controller => 'group', :action => 'list'
map.connect 'group/show/:id', :controller => 'group', :action => 'show'
map.connect 'group/new', :controller => 'group', :action => 'new'
map.connect 'group/create', :controller => 'group', :action => 'create'
map.connect 'group/delete/:id', :controller => 'group', :action => 'delete'
map.connect 'group/members/:id', :controller => 'group', :action => 'members'
map.connect 'group/members/update/:id', :controller => 'group', :action => 'update_members'

map.connect 'region/list', :controller => 'region', :action => 'list'
map.connect 'region/show/:id', :controller => 'region', :action => 'show'
map.connect 'region/new', :controller => 'region', :action => 'new'
map.connect 'region/create', :controller => 'region', :action => 'create'
map.connect 'region/delete/:id', :controller => 'region', :action => 'delete'

map.connect 'membershiptype/list', :controller => 'membershiptype', :action => 'list'
map.connect 'membershiptype/show/:id', :controller => 'membershiptype', :action => 'show'
map.connect 'membershiptype/new', :controller => 'membershiptype', :action => 'new'
map.connect 'membershiptype/create', :controller => 'membershiptype', :action => 'create'
map.connect 'membershiptype/delete/:id', :controller => 'membershiptype', :action => 'delete'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
