SaltAndSea::Application.routes.draw do

  resources :text_entries


resources :processed_locations, :preferences, :customers, :hold_dates, :customer_credits, :used_customer_credits, :products, :line_items, :current_cart, :drop_locations, :payment_notifications
  #map.current_cart 'cart', :controller => 'carts', :action => 'show', :id => 'current'

  match "/cart/:id" => "carts#show"
  match "my_account" => "home#my_account", :as => :account
  match "cart" => "home#my_cart", :as => :cart
  match "products" => "home"
  match "checkout" => "home#checkout"  
  get "home/index"
  get "home/my_account"
  get "home/show_cart"
  get "home/checkout"
  get "orders/test"
  get "home/products"
  get "orders/pay_by_check"
  match "show_invoice" => "home#show_invoice"
  
  match "/admin/low_credit_notifications" => "admin#low_credit_notifications"
  get "admin/index"
  
  devise_for :users do get '/users/new' => 'users#new', :as => :new_user end
  devise_for :users do get '/users/show' => 'users#show', :as => :user end
  devise_for :users do get '/users/edit' => 'users#edit', :as => :edit_user end
  devise_for :users do get '/users/sign_out' => 'devise/sessions#destroy' end  
  devise_for :users do match 'sign_up' => 'devise/sessions#new' end  
     
  
  devise_for :users, controllers: { registrations: "registrations" }
  match 'devise/home/show_cart' => 'home#show_cart'
    
  # Paypal
   resources :orders do
    get 'express', :on => :new
   end
   
   resources :payments, only: [:show, :create, :destroy] do
     collection do
       get :success
       get :cancel
       post :notify
     end
   end
   

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
  # 
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
    match ':controller(/:action(/:id))(.:format)'
  # 
  # Devise Root
  root :to => "home#index"
  #map.connect '/home/submit_item', :controller => 'home', :action => 'submit_item'
  
  #page errors
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
  
end
