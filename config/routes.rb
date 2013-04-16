  Mss::Application.routes.draw do

  root :to => 'pages#index'
  
  devise_for :users
  
  get 'settings', :to => 'settings#show'
  put 'settings', :to => 'settings#update'
  get 'exchange', :to => 'exchange#index'
  get 'exchange/download_zip', :to => 'exchange#download_zip'
  get 'exchange/send_to_ftp', :to => 'exchange#send_to_ftp'
  post 'exchange/upload', :to => 'exchange#upload'  
  get 'profile/show', :to => 'profiles#show'
  match 'profile/edit', :to => 'profiles#edit'
  put 'profile/update', :to => 'profiles#update'
  match 'profile/edit_password', :to => 'profiles#edit_password'
  put 'profile/update_password', :to => 'profiles#update_password'
  get 'bali', :to => 'pages#bali'
  
  # MobileSynchronization routes
  get 'synchronization/customers', :to => 'mobile_synchronization#customers'
  get 'synchronization/managers', :to => 'mobile_synchronization#managers'
  get 'synchronization/categories', :to => 'mobile_synchronization#categories'    
  get 'synchronization/products', :to => 'mobile_synchronization#products'
  get 'synchronization/warehouses', :to => 'mobile_synchronization#warehouses'
  get 'synchronization/statuses', :to => 'mobile_synchronization#statuses'
  get 'synchronization/price_lists', :to => 'mobile_synchronization#price_lists'
  get 'synchronization/unit_of_measures', :to => 'mobile_synchronization#unit_of_measures'
  get 'synchronization/template_routes', :to => 'mobile_synchronization#template_routes'
  post 'synchronization/routes', :to => 'mobile_synchronization#routes'
  post 'synchronization/orders', :to => 'mobile_synchronization#orders'
  
  resources :orders do
    member do
        put :export_again
        get :generate_xml        
      end
    resources :order_items do      
        get :update_product_unit_of_measures
        collection do
          get :update_product_unit_of_measures
        end               
    end    
  end 
  resources :routes do
    collection do
      get :current
    end       
    resources :route_points
  end
  resources :template_routes do
    resources :template_route_points
  end
  resources :unit_of_measures   
  resources :products do      
    resources :product_prices    
    resources :product_unit_of_measures
  end
  resources :managers do
    resources :manager_shipping_addresses    
  end
  resources :statuses
  resources :customers do
    resources  :shipping_addresses
  end
  resources :users do
    member do
      match :edit_password
      put :update_password
    end
  end
  resources :price_lists do
    resources :price_list_lines
  end
  resources :warehouses
  resources :categories
  
end
