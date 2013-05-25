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
  get 'orders/order_items/update_product_unit_of_measures', :to => 'order_items#update_product_unit_of_measures'
  get 'reports', :to => 'reports#index'
  get 'reports/orders', :to => 'reports#orders'
  get 'reports/routes', :to => 'reports#routes'
  get 'reports/template_routes', :to => 'reports#template_routes'
  
  # MobileSynchronization routes
  get 'synchronization/datetime', :to => 'mobile_synchronization#datetime'
  get 'synchronization/settings', :to => 'mobile_synchronization#settings'
  get 'synchronization/customers', :to => 'mobile_synchronization#customers'
  get 'synchronization/shipping_addresses', :to => 'mobile_synchronization#shipping_addresses'
  get 'synchronization/manager', :to => 'mobile_synchronization#manager'
  get 'synchronization/manager_shipping_addresses', :to => 'mobile_synchronization#manager_shipping_addresses'
  get 'synchronization/categories', :to => 'mobile_synchronization#categories'    
  get 'synchronization/products', :to => 'mobile_synchronization#products'
  get 'synchronization/product_unit_of_measures', :to => 'mobile_synchronization#product_unit_of_measures'
  get 'synchronization/product_prices', :to => 'mobile_synchronization#product_prices'
  get 'synchronization/warehouses', :to => 'mobile_synchronization#warehouses'
  get 'synchronization/statuses', :to => 'mobile_synchronization#statuses'
  get 'synchronization/price_lists', :to => 'mobile_synchronization#price_lists'
  get 'synchronization/unit_of_measures', :to => 'mobile_synchronization#unit_of_measures'
  get 'synchronization/template_routes', :to => 'mobile_synchronization#template_routes'
  get 'synchronization/template_route_points', :to => 'mobile_synchronization#template_route_points'
  post 'synchronization/routes', :to => 'mobile_synchronization#routes'
  post 'synchronization/orders', :to => 'mobile_synchronization#orders'
  
  resources :orders do
    member do
        put :export_again
        get :generate_xml       
      end
    collection do
      get :update_shipping_addresses
      post :multiple_change
    end  
    resources :order_items do
        collection do
          post :multiple_change
        end               
    end    
  end 
  resources :routes do
    collection do
      get :current
      post :multiple_change
    end       
    resources :route_points do
      collection do
        post :multiple_change
      end 
    end
  end
  resources :template_routes do
    collection do
      post :multiple_change
    end
    resources :template_route_points do
      collection do
        post :multiple_change
      end
    end
  end
  resources :unit_of_measures do
    collection do
      post :multiple_change
    end
  end  
  resources :products do 
    collection do
      post :multiple_change
    end     
    resources :product_prices do
      collection do
        post :multiple_change
      end
    end    
    resources :product_unit_of_measures do
      collection do
        post :multiple_change
      end
    end
  end
  resources :managers do
    collection do
      post :multiple_change
    end
    resources :manager_shipping_addresses do
      collection do
        post :multiple_change
      end
    end
  end
  resources :statuses do
    collection do
      post :multiple_change
    end
  end
  resources :customers do
    collection do
      post :multiple_change
    end
    resources  :shipping_addresses do
      collection do
        post :multiple_change
      end
    end
  end
  resources :users do
    collection do
      post :multiple_change
    end
    member do
      match :edit_password
      put :update_password
    end
  end
  resources :price_lists do
    collection do
      post :multiple_change
    end
    resources :price_list_lines do
      collection do
        post :multiple_change
      end
    end
  end
  resources :warehouses do
    collection do
      post :multiple_change
    end
  end
  resources :categories do
    collection do
      post :multiple_change
    end
  end
  
end
