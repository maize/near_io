require 'resque/server'

Near::Application.routes.draw do
  resources :networks

  match ":id", :to => "networks#show"
  match ":id/:year/:month/:day",
      :to => "networks#show",
      :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ },
      :as => :network_date
  match "networks/:id/update_groups", :to => "networks#update_groups"
  match "networks/:id/clear_queue", :to => "networks#clear_queue"

  resources :groups
  match "groups/:id/update_details", :to => "groups#update_details"
  match "groups/:id/events", :to => "groups#events"

  resources :events
  match "events/:id", :to => "events#show", :as => 'facebook_event'
  match "events/:id/update_details", :to => "events#update_details"

  match "users/facebook", :to => "users#facebook", :as => 'facebook_users'
  match "users/:id/make_admin", :to => "users#make_admin", :as => 'user_make_admin'
  match "users/:id/likes", :to => "users#likes", :as => 'user_likes'
  match "users/:id/following_places", :to => "users#following_places", :as => 'user_following_places'

  root :to => 'networks#index'

  mount Resque::Server.new, :at => "/resque"

  devise_for :users, :path => "user", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users

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
