Rails.application.routes.draw do

  namespace :admin do
    resources :media
    resources :categories
    resources :products
    resources :pricing_plans
    resources :users
    resources :subscriptions
    root to: "media#index"
  end

  devise_for :users, controllers: { sessions: 'users/sessions',
                                    registrations: 'users/registrations' }

  devise_scope :user do
    get 'profile' => 'users/registrations#profile'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'
  get 'purchases', to: 'dashboard#purchases', as: 'purchases'
  get 'index', to: 'pages#index', as: 'index' # landing page
  resources :products
  resources :categories, only: [:index, :show]
  get 'media/:number', to: 'media#show', as: 'media'
  resource :checkout, only: :create
  resources :orders, only: [:new, :create]
  resources :favorite_media, only: [:create, :destroy]
  resources :subscriptions
  resources :ebooks
  
  get 'music', to: 'categories#music', as: 'music'
  get 'search', to: 'search#index', as: 'search'
  
  get '*unmatched', to: 'application#not_found'
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
