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

			namespace :variants do
				resources :variants, format: :json
			end

			namespace :categories do
				resources :categories, format: :json
				post :get_all_cat_and_subcat, to: :get_all_cat_and_subcat, controller: :categories
			end

			namespace :charges do
				resources :charges, format: :json
			end

			namespace :businessplace do
				resources :businessplace, format: :json
			end

			namespace :businesssucursal do
				resources :businesssucursal, format: :json
			end

		end
	end

end
