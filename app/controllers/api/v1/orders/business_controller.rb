class Api::V1::Orders::BusinessController < ApplicationController
	before_action :validate_authentification_token

	def business_order_product
		if @user
			products = params[:products]
			list = []
			products.each do |p|
				business_product = BusinessProduct.new(quantity: p[:quantity], product_id: p[:id],
					type_measure: p[:type_measure], user_id: @user.id)
				product = Product.find_by(id: business_product.product_id)
				k = 0;
				case product.type_size
				when 1
					case business_product[:type_measure]
					when 1
						k = 1
					when 2
						k = 0.5
					when 3
						k = 0.001
					end
					case product.type_measure
					when 1
						l = 1
					when 2
						l = 2
					when 3
						l = 1000
					end
				when 2
					case business_product[:type_measure]
					when 1
						k = 1
					when 2
						k = 0.001
					end
					case product.type_measure
					when 1
						l = 1
					when 2
						l = 1000
					end
				end
				business_product[:quantity] = business_product[:quantity] * k * l;
				if business_product.save
					list << business_product
				end
			end
			if list.length == products.length
				render :json => list, status: :ok
			else
				render :json => products, status: :bad_request	
			end
		end
	end

	def get_business_order_product
		if @user
			sucursal = BusinessSucursal.find_by(id: @user.sucursal_id)
			users = User.where(sucursal_id: sucursal.id, active: true)
			response = [];
			users.each do |u|
				temp = {user: u, businessproducts: []}
				products = BusinessProduct.where(user_id: u.id)
				products.each do |p|
					temp_p = {product: p, product_info: Product.find_by(id: p.product_id)}
					temp[:businessproducts] << temp_p
				end
				response << temp
			end
			render :json => response, status: :ok
		end
	end

	def accept_business_order_product
		if @user
			render :json => 2, status: :ok
		end
	end

	def del_business_order_product
		if @user
			render :json => 2, status: :ok
		end
	end

end