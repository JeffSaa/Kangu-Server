Rails.application.routes.draw do
	root 'welcome#index'

	namespace :v1, :defaults => { :format => 'json' } do
		
		namespace :products do
			resources :products, format: :json
			post :search_product, to: :search_product, controller: :products
			post :products_excel_creator, to: :products_excel_creator, controller: :products
		end

		namespace :variants do
			resources :variants, format: :json
			get :search, to: :search, controller: :variants
		end

		namespace :categories do
			resources :categories, format: :json
			get :search, to: :search, controller: :categories
		end

		namespace :charge do
			resources :charge, format: :json
		end

		namespace :businessplace do
			resources :businessplace, format: :json
			get :search, to: :search, controller: :businessplace
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
			post :remove_product, to: :remove_product, controller: :orders
			post :add_product, to: :add_product, controller: :orders
			put :update_product, to: :update_product, controller: :orders
			get :search_orderproduct, to: :search_orderproduct, controller: :orders
		end

		namespace :users do
			resources :users, format: :json
			get :search, to: :search, controller: :users
			resources :login, format: :json
			resources :logout, format: :json
			post :register, to: :register, controller: :register
		end

		namespace :administration do
			post :close_day, to: :close_day, controller: :accounting
			post :inventory_entry, to: :inventory_entry, controller: :accounting
			post :income_expenses, to: :income_expenses, controller: :accounting
		end

		namespace :creditnote do
			resources :creditnote, format: :json
		end

		namespace :providers do
			resources :providers, format: :json
			get :search, to: :search, controller: :providers
			post :assign, to: :assign, controller: :providers
		end

	end

end
