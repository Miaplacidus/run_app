Rails.application.routes.draw do

  root :to => 'users#dashboard'

  match 'auth/:provider/callback', to: 'sessions#attempt_login', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]


  match 'sessions/logout', to: 'sessions#logout', :via => :get

  match 'users/dashboard', to: 'users#dashboard', :via => :get

  match 'circles/display', to: 'circles#display', :via => :get
  match 'circles/challenge', to: 'circles#challenge', :via => :post
  match 'circles/admin', to: 'circles#admin', :via => :get
  match 'circles/adminview', to: 'circles#adminview', :via => :get
  match 'circles/show', to: 'circles#show', :via => :get
  match 'circles/circleposts', to: 'circles#circleposts', :via => :get
  match 'circles/getpostform', to: 'circles#getpostform', :via => :get
  match 'circles/createcirclepost', to: 'circles#createcirclepost', :via => :post

  match 'join_requests/create', to: 'join_requests#create', :via => :post
  match 'join_requests/adminlist', to: 'join_requests#adminlist', :via => :get
  match 'join_requests/decide', to: 'join_requests#decide', :via => :post

  match 'posts/display', to: 'posts#display', :via => :get
  match 'posts/show', to: 'posts#show', :via => :get
  match 'posts/admin', to: 'posts#admin', :via => :get
  match 'posts/adminview', to: 'posts#adminview', :via => :get
  match 'posts/checkin', to: 'posts#checkin', :via => :put
  match 'posts/join', to: 'posts#join', :via => :post

  match 'users/delete', to: 'users#delete', :via => :get
  match 'users/destroy', to: 'users#destroy', :via => :delete

  resources :challenges
  resources :circles
  resources :commitments
  resources :join_requests
  resources :posts
  resources :users
  resources :wallets


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
