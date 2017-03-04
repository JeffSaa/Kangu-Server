class Api::V1::Orders::BusinessController < ApplicationController
	before_action :validate_authentification_token

	def business_order_product
		if @user
			products = params[:products]
			list = []
			products.each do |p|
				business_product = BusinessProduct.new(quantity: p[:quantity], product_id: p[:id],
					type_measure: p[:type_measure], user_id: @user.id)
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
				temp = {user: u, products: BusinessProduct.where(user_id: u.id)}
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