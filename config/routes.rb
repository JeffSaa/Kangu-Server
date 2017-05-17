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

		end
	end

end
