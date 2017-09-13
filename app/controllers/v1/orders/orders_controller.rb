class V1::Orders::OrdersController < ApplicationController
	before_action :validate_authentification_token, :except => [:show_by_uid]

	def create
		order = Order.new(order_params)
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			order.status = params[:status]
			order.target_id = params[:target_id]
		else
			order.target_id = @current_user.id
		end
		response = {order_info: order, products: []}
		if order.save
			total = 0
			params[:products].each do |p|
				op = OrderProduct.new(orderproduct_params(p))
				op.price = get_product_price(ProductVariant.find(op.variant_id))
				total += op.price * op.quantity
				op.last_quantity = op.quantity
				op.order_id = order.id
				op.iva = ProductVariant.find(p[:variant_id]).iva
				if op.save
					response[:products] << op
				end
			end
			if order.update(total: total)
				render :json => response, status: :ok
			end
		end
	end

	def index
		response = []
		Order.where(status: params[:status]).each{|o| response << render_order(o)}
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
		case order.status
		when 1
			total = 0
			products = OrderProduct.where(order_id: order.id)
			products.each do |p|
				variant = ProductVariant.find(p.variant_id)
				if p.update(price: get_product_price(variant), iva: variant.iva)
					total += p.price * p.quantity
				end
			end
			sucursal = BusinessSucursal.find(order.target_id)
			sucursal.update(order_count: sucursal.order_count + 1)
			consecutive = Order.where(status: 3).count + Order.where(status: 4).count + 1
			order.update(consecutive: consecutive, total: total, status: order.status+1)
			render :json => order, status: :ok
		else
			if order.update(status: order.status+1)
				render :json => order, status: :ok
			end
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

	def show_by_uid
		order = Order.find_by(uid: params[:uid])
		render :json => render_order(order), status: :ok
	end

	private

	def render_order(order)
		products = []
		order_products = OrderProduct.where(order_id: order.id)
		order_products.each do |op|
			variant = ProductVariant.find(op.variant_id)
			products << {order_product: op, variant: variant, product: Product.find(variant.product_id)}
		end
		iva = []
		[0, 0.05, 0.16].each do |i|
			total = 0
			order_products.where(iva: i).each{|op| total += op.price * op.quantity}
			iva << [total , total * i]
		end
		sucursal = BusinessSucursal.find(order.target_id)
		place = BusinessPlace.find(sucursal.business_id)
		return {order: order, products: products, sucursal: sucursal, place: place, iva: iva}
	end

	def update_orderproduct_params(p)
		p.permit(:quantity, :comment, :status)
	end

	def change_status(status, id)
		order = Order.find(id)
		consecutive = nil
		if status == 4
			consecutive = Order.where(status: 3).count + Order.where(status: 4).count + 1
		end
		if order.update(status: status, consecutive: consecutive)
			render :json => order, status: :ok
		end
	end

	def order_params
		params.permit(:comment, :datehour, :order_type, :pay_mode)
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