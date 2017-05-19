Rails.application.routes.draw do
	root 'welcome#index'

	namespace :api do
		namespace :v1 do

			namespace :userapp do
				resources :login, format: :json
				resources :logout, format: :json
				post :register, to: :register, controller: :register
			end

			namespace :products do
				resources :products, format: :json
				post :search_product, to: :search_product, controller: :products
			end

			namespace :variant do
				resources :variant, format: :json
			end

			namespace :categorie do
				resources :categorie, format: :json
				post :get_all_cat_and_subcat, to: :get_all_cat_and_subcat, controller: :categories
			end

			namespace :charge do
				resources :charge, format: :json
			end

			namespace :businessplace do
				resources :businessplace, format: :json
				post :search, to: :search, controller: :businessplace
			end

			namespace :businesssucursal do
				resources :businesssucursal, format: :json
				post :search, to: :search, controller: :businesssucursal
			end

			namespace :orders do
				resources :orders, format: :json
			end

			namespace :users do
				resources :users, format: :json
			end

		end
	end

end
