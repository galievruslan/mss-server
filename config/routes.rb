Mss::Application.routes.draw do
  resources :template_route_points


  resources :template_routes


  get "pages/index"

  devise_for :users

  match 'orders/generate_xml', :to => 'orders#generate_xml'
  get 'routes/create_use_template', :to => 'routes#create_use_template'
  resources :orders do
    member do
        put :export_again        
      end
    resources :order_items    
  end 
  resources :routes do       
    resources :route_points
  end
  resources :template_routes do
    resources :template_route_points
  end   
  resources :products
  resources :managers
  resources :statuses
  resources :customers do
    resources  :shipping_addresses
  end
  resources :users
  
  get 'exchange', :to => 'exchange#index'
  get 'exchange/get_xml', :to => 'exchange#get_orders'
  post 'exchange/upload', :to => 'exchange#upload'
  root :to => 'pages#index'
  get 'bali', :to => 'pages#bali'
  
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
