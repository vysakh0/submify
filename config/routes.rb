require 'sidekiq/web'
Youarel::Application.routes.draw do

  mount Sidekiq::Web, at: '/sidekiq'
  resources :users do
    collection { get :search }
  end
  match '/autocomplete', to: 'static_pages#autocomplete', as: 'autocomplete'

  match '/autocomplete_topic', to: 'static_pages#autocomplete_topic_name', as: 'autocomplete_topic'
  match '/contact', to: 'static_pages#contact'
  resources :users do
    member do
      get :following, :followers, :commented, :followed_topics

      get :links, :comments, :follower
      post :links, :comments, :follower
    end
  end
  resources :topics do
    member do
      get :following_users
    end
  end

  match '/front', to: 'static_pages#front_page'
  resources :votes, only: [:create, :destroy]
  resources :downvotes, only: [:create, :destroy]
  resources :topics, only: [:create, :destroy, :show, :edit ]

  resources :flags, only: [:create, :destroy]
  resources :link_users, only: [:create, :destroy]
  resources :links, only: [:create, :destroy, :show, :submit]
  resources :sessions, only: [:new, :create, :destroy]

  resources :relationships, only: [:create, :destroy]

  resources :topic_user_relationships, only: [:create, :destroy]
  resources :links do
    resources :comments, only: [:create, :destroy, :show]
  end

  resources :links do
    member do
      post 'submit'
    end
  end
  resources :topics do
    member do
      post 'unsubmit'
    end
  end
  resources :comments do

    resources :comments, only: [:create, :destroy, :show]
  end
  #  match '/signin', to: 'sessions#new'
  match '/auth/:provider/callback', to: 'sessions#new'
  match '/auth/failure', to: 'sessions#failure'
  match '/signup', to: 'users#new'
  match '/signout', to: 'sessions#destroy', via: :delete
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
