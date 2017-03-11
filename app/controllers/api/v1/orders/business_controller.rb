class Api::V1::Orders::BusinessController < ApplicationController
	before_action :validate_authentification_token

	def business_order_product
		if @user
			products = params[:products]
			list = []
			products.each do |p|
				business_product = BusinessProduct.new(quantity: p[:quantity], product_id: p[:id],
					user_id: @user.id, comment: p[:comment])
				product = Product.find_by(id: business_product.product_id)
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
			order = Order.new(order_params)
			order.user_id = @user.sucursal_id
			order.status = 0
			order.order_type = 0
			productos = []
			if order.save
				params[:products].each do |p|
					order_product = OrderProduct.new()
					order_product.order_id = order.id
					order_product.product_id = p[:product_info][:id]
					order_product.price = get_product_price(p)
					order_product.user_id = @user.id
					order_product.comment = p[:product][:comment]
					order_product.quantity = p[:product][:quantity]
					order_product.order_id = order.id
					BusinessProduct.find_by(id: p[:product][:id]).destroy
					if order_product.save
						productos << order_product
						total = order.due + order_product.price * order_product.quantity
						order.update(due: total)
					end
				end
				render :json => order, status: :ok
			end
		end
	end

	def del_business_order_product
		if @user
			render :json => 2, status: :ok
		end
	end

	def get_orders_sucursal
		if @user
			case @user.type_id
			when 301
				places = BusinessPlace.where(user_id: @user.id)
				response = []
				places.each do |p|
					sucursals = BusinessSucursal.where(business_id: p.id)
					sucursals.each do |s|
						orders = Order.where(user_id: s.id).order(:status)
						orders.each do |o|
							temp = {sucursal: s, order: o}
							response << temp
						end
					end
				end
				render :json => response, status: :ok
			else
				orders = Order.where(user_id: @user.sucursal_id).order(:status)
				response = []
				sucursal = BusinessSucursal.find_by(id: @user.sucursal_id)
				orders.each do |o|
					temp = {sucursal: sucursal, order: o}
					response << temp
				end
				render :json => response, status: :ok
			end
		end
	end

	private

	def order_params
		params.permit(:date, :hour, :comment)
	end

end