Rails.application.routes.draw do
  root 'welcome#index'

  namespace :api do
  	namespace :v1 do

  		namespace :business do
  			resources :register, format: :json
  			resources :login, format: :json
  			resources :business, format: :json
        resources :sucursal, format: :json
  		end

      namespace :sucursal do
        resources :register, format: :json
      end

      namespace :userapp do
        resources :logout, format: :json
      end

  	end
  end

end
