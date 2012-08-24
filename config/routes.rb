require 'resque/server'

Near::Application.routes.draw do
  resources :networks
  match "networks/:id/update_groups", :to => "networks#update_groups"
  match "networks/:id/clear_queue", :to => "networks#clear_queue"

  resources :groups

  resources :events
  match "events/:id", :to => "events#show", :as => 'facebook_event'
  match "events/:id/update_details", :to => "events#update_details"

  resources :users
  match "users/:id/likes", :to => "users#likes", :as => 'user_likes'
  match "users/:id/following_places", :to => "users#following_places", :as => 'user_following_places'

  devise_for :users, :path => "user", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :places

  match "places/search", :to => "places#search", :as => 'search_place'
  match "places/:id/follow", :to => "places#follow", :as => 'follow_place'
  match "places/:id/unfollow", :to => "places#unfollow", :as => 'unfollow_place'

  root :to => 'events#index'

  mount Resque::Server.new, :at => "/resque"

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
