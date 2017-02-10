Rails.application.routes.draw do
  root 'welcome#index'

  namespace :api do
  	namespace :v1 do

  		namespace :business do
  			resources :business, format: :json
  		end

      namespace :sucursal do
        resources :search, format: :json
      end

      namespace :userapp do
        resources :login, format: :json
        resources :logout, format: :json
        post 'business', to: :business, controller: 'register'
        post 'business_employee', to: :business_employee, controller: 'register'
      end

      namespace :products do
      end

      namespace :orders do
      end

  	end
  end

end
