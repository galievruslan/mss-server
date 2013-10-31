  Mss::Application.routes.draw do 
    
  root :to => 'pages#index'  
  devise_for :users  
  get 'settings', :to => 'settings#show'
  put 'settings', :to => 'settings#update'
  put 'settings/update_crontab', :to => 'settings#update_crontab'
  get 'exchange', :to => 'exchange#index'
  get 'exchange/download_zip', :to => 'exchange#download_zip'
  get 'exchange/send_to_ftp', :to => 'exchange#send_to_ftp'
  post 'exchange/upload', :to => 'exchange#upload'  
  get 'profile/show', :to => 'profiles#show'  
  put 'profile/update', :to => 'profiles#update'
  put 'profile/update_password', :to => 'profiles#update_password'
  match 'profile/edit', :to => 'profiles#edit'
  match 'profile/edit_password', :to => 'profiles#edit_password'  
  get 'bali', :to => 'pages#bali'
  get 'orders/order_items/update_product_unit_of_measures', :to => 'order_items#update_product_unit_of_measures'  
  get 'route_point_photos', to: 'route_point_photos#list'
  # Reports
  get 'reports', :to => 'reports#index'
  get 'reports/orders', :to => 'reports#orders'
  get 'reports/routes', :to => 'reports#routes'
  get 'reports/template_routes', :to => 'reports#template_routes'
  get 'reports/customer_debts', :to => 'reports#customer_debts'
  get 'reports/remainders', :to => 'reports#remainders'
  get 'reports/locations', :to => 'reports#locations'
  get 'reports/audit_documents', :to => 'reports#audit_documents'
  
  # MobileSynchronization routes
  get 'synchronization/mobile_client', :to => 'mobile_synchronization#mobile_client'  
  get 'synchronization/messages', :to => 'mobile_synchronization#messages'  
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
  get 'synchronization/remainders', :to => 'mobile_synchronization#remainders'
  post 'synchronization/routes', :to => 'mobile_synchronization#routes'
  post 'synchronization/orders', :to => 'mobile_synchronization#orders'
  post 'synchronization/client_information', :to => 'mobile_synchronization#client_information'
  post 'synchronization/route_point_photos', :to => 'mobile_synchronization#route_point_photos'
  post 'synchronization/locations', :to => 'mobile_synchronization#locations'
  post 'synchronization/audit_documents', :to => 'mobile_synchronization#audit_documents'
  
  resources :orders do
    member do
        put :export_again
        get :generate_xml       
      end
    collection do
      get :update_shipping_addresses
      get :get_product_list
      get :get_unit_of_measures
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
      get :get_shipping_address_list
      post :multiple_change
    end       
    resources :route_points do
      resources :route_point_photos, as: 'photos', path: 'photos' do
        member do
          get :download
        end
      end      
      collection do
        post :multiple_change
      end 
    end
  end  
  resources :template_routes, except: :destroy do
    member do
      put :set_valid
      put :set_invalid
    end
    collection do
      get :get_shipping_address_list
      post :multiple_change
    end
    resources :template_route_points, except: :destroy do
      member do
        put :set_valid
        put :set_invalid
      end
      collection do
        post :multiple_change
      end
    end
  end
  resources :unit_of_measures, except: :destroy do
    member do
      put :set_valid
      put :set_invalid
    end
    collection do
      post :multiple_change
    end
  end  
  resources :products, except: :destroy do 
    collection do
      post :multiple_change
    end
    member do
      put :set_valid
      put :set_invalid
      get 'unit_of_measures/:unit_of_measure_id' => 'products#unit_of_measures'        
    end
    resources :product_prices, except: :destroy do
      member do
        put :set_valid
        put :set_invalid
      end
      collection do
        post :multiple_change
      end
    end    
    resources :product_unit_of_measures, except: :destroy do
      member do
        put :set_valid
        put :set_invalid
      end
      collection do
        post :multiple_change
      end
    end
  end
  resources :managers, except: :destroy do
    member do
      put :set_valid
      put :set_invalid
    end
    collection do
      post :multiple_change
    end
    resources :manager_warehouses, except: :destroy do
      member do
        put :set_valid
        put :set_invalid
      end
      collection do
        post :multiple_change
      end
    end
    resources :manager_shipping_addresses, except: :destroy do
      member do
        put :set_valid
        put :set_invalid
      end
      collection do
        post :multiple_change
      end
    end
  end
  resources :statuses, except: :destroy do
    member do
      put :set_valid
      put :set_invalid
    end
    collection do
      post :multiple_change
    end
  end
  resources :customers, except: :destroy do
    collection do
      post :multiple_change
    end
    member do
      put :set_valid
      put :set_invalid
    end
    resources  :shipping_addresses, except: :destroy do
      member do 
        put :set_valid
        put :set_invalid
      end
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
      get :edit_password
      put :update_password
    end
  end
  resources :price_lists, except: :destroy do
    member do
      put :set_valid
      put :set_invalid
      get 'products/:product_id' => 'price_lists#show_products'
    end
    collection do
      post :multiple_change
    end
    resources :price_list_lines, except: :destroy do
      member do 
        put :set_valid
        put :set_invalid
      end
      collection do
        post :multiple_change
      end
    end
  end
  resources :warehouses, except: :destroy do
    member do
      put :set_valid
      put :set_invalid
    end
    collection do
      post :multiple_change
    end
  end
  resources :categories, except: :destroy do
    member do
      put :set_valid
      put :set_invalid
    end
    collection do
      post :multiple_change
    end
  end
  
  resources :mobile_clients
  resources :groups
  resources :messages do
    member do
      get :read
    end
    collection do
      post :multiple_change
    end
  end
  resources :remainders do
    collection do
      get :get_remainder
      post :multiple_change
    end
  end
  resources :audit_documents do
    collection do
      get :update_shipping_addresses      
      get :get_product_list
      post :multiple_change
    end 
    resources :audit_document_items do
      collection do
      post :multiple_change
    end
    end
  end
end
