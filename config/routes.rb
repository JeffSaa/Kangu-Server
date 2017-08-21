Rails.application.routes.draw do
	root 'welcome#index'

	namespace :v1 do
		
		namespace :products do
			resources :products, format: :json
			post :search_product, to: :search_product, controller: :products
			post :products_excel_creator, to: :products_excel_creator, controller: :products
		end

		namespace :variants do
			resources :variants, format: :json
			get :search, to: :search, controller: :variants
			post :excel_updater, to: :excel_updater, controller: :variants
		end

		namespace :categories do
			resources :categories, format: :json
			post :search_subcategorie, to: :search_subcategorie, controller: :categories
		end

		namespace :charge do
			resources :charge, format: :json
		end

		namespace :businessplace do
			resources :businessplace, format: :json
			post :search, to: :search, controller: :businessplace
			post :credit_status, to: :credit_status, controller: :businessplace
		end

		namespace :businesssucursal do
			resources :businesssucursal, format: :json
			post :search, to: :search, controller: :businesssucursal
			get :admins, to: :admins, controller: :businesssucursal
		end

		namespace :orders do
			resources :orders, format: :json
			post :advance, to: :advance, controller: :orders
			post :return, to: :return, controller: :orders
			post :disable, to: :disable, controller: :orders
			put :update_status, to: :update_status, controller: :orders
			get :day_shop, to: :day_shop, controller: :orders
			get :find_by_consecutive, to: :find_by_consecutive, controller: :orders
			post :show_by_uid, to: :show_by_uid, controller: :orders
		end

		namespace :users do
			resources :users, format: :json
			post :search, to: :search, controller: :users
			resources :login, format: :json
			resources :logout, format: :json
			post :register, to: :register, controller: :register
		end

		namespace :administration do
			post :close_day, to: :close_day, controller: :accounting
			post :inventory_entry, to: :inventory_entry, controller: :accounting
		end

		namespace :creditnote do
			resources :creditnote, format: :json
		end

		namespace :providers do
			resources :providers, format: :json
			get :search, to: :search, controller: :providers
		end

	end

end
