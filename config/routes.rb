class AdminConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    user = User.find request.session[:user_id]
    user && user.admin?
  end
end

require 'sidekiq/web'
Youarel::Application.routes.draw do


  mount Sidekiq::Web, at: '/sidekiq', :constraints => AdminConstraint.new

  resources :password_resets
  resources :votes, only: [:create, :destroy]
  resources :downvotes, only: [:create, :destroy]
  resources :topics, only: [:create, :destroy, :show, :edit ]
  resources :flags, only: [:create, :destroy]
  resources :links, only: [:create, :destroy, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :topic_user_relationships, only: [:create, :destroy]
  resources :links do
    resources :comments, only: [:create, :destroy, :show]
  end
  resources :links do
    member do
      post 'submit', 'unsubmit'
    end
  end
  resources :comments do
    resources :comments, only: [:create, :destroy, :show]
  end
  resources :topics do
    member do
      get :following_users, :hovercard
    end
  end
  resources :users do
    member do
      get :following, :followers, :commented, :followed_topics, :hovercard, :notifications
    end
  end
  #  match '/signin', to: 'sessions#new'
  match '/admin', to: 'admin#links'
  match '/admin/comments', to: 'admin#comments'
  match '/admin/topics', to: 'admin#topics'
  match '/contact', to: 'static_pages#contact'
  match '/front', to: 'static_pages#front_page'
  match '/auth/:provider/callback', to: 'sessions#fb'
  match '/auth/failure', to: 'sessions#failure'
  match '/signup', to: 'users#new'
  match 'privacy', to: 'static_pages#privacy'
  match 'show_signup', to: 'sessions#show_signup'
  match 'show_signin', to: 'sessions#show_signin'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/autocomplete', to: 'static_pages#autocomplete', as: 'autocomplete'

  match '/autocomplete_topic', to: 'static_pages#autocomplete_topic_name', as: 'autocomplete_topic'
  root to: 'static_pages#home'
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
