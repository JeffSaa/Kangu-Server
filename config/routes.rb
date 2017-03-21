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
				post 'supervisor', to: :supervisor, controller: 'register'
				post 'administrator', to: :administrator, controller: 'register'
				post 'confirmation_email', to: :confirmation_email, controller: 'register'
			end

			namespace :products do
				resources :products, format: :json
				post 'search_product', to: :search_product, controller: 'products'
			end

			namespace :orders do
				resources :business, format: :json
				post 'business_order_product', to: :business_order_product, controller: 'business'
				post 'get_business_order_product', to: :get_business_order_product, controller: 'business'
				post 'accept_business_order_product', to: :accept_business_order_product, controller: 'business'
				post 'del_business_order_product', to: :del_business_order_product, controller: 'business'
				post 'get_orders_sucursal', to: :get_orders_sucursal, controller: 'business'
				post 'get_supervisor_orders', to: :get_supervisor_orders, controller: 'supervisor'
				post 'change_order_status', to: :change_order_status, controller: 'supervisor'
			end

			namespace :categories do
				resources :categories, format: :json
				post 'searchsub', to: :searchsub, controller: 'categories'
				get 'get_all_cat_and_subcat', to: :get_all_cat_and_subcat, controller: 'categories'
				get 'get_main_categories', to: :get_main_categories, controller: 'categories'
				post 'get_products_categories', to: :get_products_categories, controller: 'categories'
			end

			namespace :providers do
				post 'search', to: :search, controller: 'provider'
			end

		end
	end

end
