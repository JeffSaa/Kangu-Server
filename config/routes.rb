Rails.application.routes.draw do
  root 'welcome#index'

  namespace :api do
  	namespace :v1 do

  		namespace :business do
  			resources :business, format: :json
        post 'search_business', to: :search_business, controller: 'business'
        post 'all_my_business', to: :all_my_business, controller: 'business'
  		end

      namespace :sucursal do
        resources :sucursal, format: :json
        post 'get_user_request', to: :get_user_request, controller: 'sucursal'
        post 'accept_user_request', to: :accept_user_request, controller: 'sucursal'
        post 'search_sucursal', to: :search_sucursal, controller: 'sucursal'
        post 'get_all_sucursal_ofplace', to: :get_all_sucursal_ofplace, controller: 'sucursal'
      end

      namespace :userapp do
        resources :login, format: :json
        resources :logout, format: :json
        post 'provider', to: :provider, controller: 'register'
        post 'business', to: :business, controller: 'register'
        post 'business_employee', to: :business_employee, controller: 'register'
      end

      namespace :products do
        resources :products, format: :json
      end

      namespace :orders do
        resources :business, format: :json
      end

      namespace :categories do
        resources :categories, format: :json
        post 'searchsub', to: :searchsub, controller: 'categories'
      end

      namespace :providers do
        post 'search', to: :search, controller: 'provider'
      end

  	end
  end

end
