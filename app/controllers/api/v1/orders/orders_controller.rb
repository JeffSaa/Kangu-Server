class Api::V1::Orders::OrdersController < ApplicationController
	before_action :validate_authentification_token

	def create
		order = Order.new(order_params)
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			order.pay_mode = params[:pay_mode]
			order.status = params[:status]
			order.target_id = params[:target_id]
			order.order_type = params[:order_type]
		else
			order.target_id = @current_user.id
		end
		response = {order_info: order, products: []}
		if order.save
			params[:products].each do |p|
				op = OrderProduct.new(orderproduct_params(p))
				op.price = get_product_price(ProductVariant.find(op.variant_id))
				op.order_id = order.id
				op.last_quantity = op.quantity
				op.provider_id = getProvider(p[:variant_id], order.target_id, order.order_type).last[:provider].id
				if op.save
					response[:products] << op
				end
			end
		end
		render :json => response, status: :ok
	end

	def index
		response = []
		orders = Order.where(status: params[:status])
		orders.each do |o|
			sucursal = BusinessSucursal.find(o.target_id)
			item =  {info: {order: o, sucursal: sucursal, business: BusinessPlace.find(sucursal.business_id)},
			products: []}
			OrderProduct.where(order_id: o.id).each do |op|
				variant = ProductVariant.find(op.variant_id)
				item[:products] << {order_product: op, variant: variant, product: Product.find(variant.product_id)}
			end
			response << item
		end
		render :json => response, status: :ok
	end

	def show
		render :json => get_order_details(Order.find(params[:id])), status: :ok
	end

	def find_by_consecutive
		render :json => get_order_details(Order.find_by(consecutive: params[:consecutive])), status: :ok
	end

	def advance
		order = Order.find(params[:id])
		if order.status < 3 and order.update(status: order.status+1)
			if order.status == 2
				total = 0
				products = OrderProduct.where(order_id: order.id)
				products.each do |p|
					variant = ProductVariant.find(p.variant_id)
					if p.update(price: get_product_price(variant), iva: variant.iva)
						total += p.price * p.quantity
					end					
				end
				order.update(consecutive: Order.where(status: 3).count + Order.where(status: 2).count + 1, total: total)
				sucursal = BusinessSucursal.find(order.target_id)
				sucursal.update(order_count: sucursal.order_count + 1)
			end
			render :json => order, status: :ok
		end
	end

	def return
		change_status(0, params[:id])
	end

	def disable
		change_status(4, params[:id])
	end

	def update_status
		response = []
		params[:products].each do |product|
			p =  OrderProduct.find(product[:id])
			p.update(last_quantity: p.quantity)
			p.update(update_orderproduct_params(product))
			response << p
		end
		render :json => response, status: :ok
	end

	def day_shop
		orders = Order.where(status: 1)
		products = []
		duplicates = []
		response = []
		orders.each do |o|
			products.push(*OrderProduct.where(order_id: o.id))
		end
		products = products.group_by{|p| p.variant_id}
		products.each do |p|
			duplicates << p.last
		end
		duplicates.each do |d|
			variant = ProductVariant.find(d.first.variant_id)
			response << {variant: variant, product: Product.find(variant.product_id), provider: getProvider(variant.id, nil, nil).last, duplicates: d,
				quantity: d.inject(0){|sum,e| sum + e.quantity}}
		end
		render :json => response, status: :ok
	end

	private

	def update_orderproduct_params(p)
		p.permit(:quantity, :comment, :status)
	end

	def change_status(status, id)
		order = Order.find(id)
		if order.update(status: status)
			render :json => order, status: :ok
		end
	end

	def order_params
		params.permit(:comment, :datehour)
	end

	def orderproduct_params(p)
		p.permit(:comment, :quantity, :variant_id)
	end

	def get_order_details(order)
		products = []
		OrderProduct.where(order_id: order.id).each{|p| products << get_orderproduct_info(p)}
		return {order: Order.find(order.id), products: products}
	end

end