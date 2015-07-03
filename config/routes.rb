Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/internal/admin', as: 'rails_admin'

  devise_for :users, class_name: 'User', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations'
  }, only: [:confirmations, :passwords]

  devise_scope :user do
    post '/v1/users' => 'users/registrations#create', as: 'user_registration'
    get '/v1/users' => 'users/registrations#new', as: 'new_user_registration'

    get '/v1/users/sign_in', to: 'users/sessions#new', as: 'new_user_session'
    post '/v1/users/sign_in', to: 'users/sessions#create', as: 'user_session'
  end

  namespace :v1, defaults: { format: :json } do
    resource :sign_in, only: [:create], controller: :sessions

    resources :news, only: [:index, :show]

    resources :contestants, only: [:index, :show, :create] do
      collection do
        post :additional
      end
    end

    post 'contestants/update_registration_step_number', to: 'contestants#update_registration_step_number'

    resources :projects, only: [:index, :show, :create] do
      member do
        post :finish
        post :screenshots
        post :collaborators
      end
    end

    get "current" => "current#index"
  end

  get "/404", :to => "errors#error_404"
  get "/422", :to => "errors#error_404"
  get "/500", :to => "errors#error_500"

  root :to => redirect("http://dev.infoeducatie.ro/")

  match '*unmatched_route', :to => 'errors#error_404', via: [:get, :put, :patch, :post,
         :delete, :copy, :head, :options, :link, :unlink, :purge, :lock, :unlock, :propfind]

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
