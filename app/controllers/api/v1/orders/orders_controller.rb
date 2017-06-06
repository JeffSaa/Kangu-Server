class Api::V1::Orders::OrdersController < ApplicationController
	before_action :validate_authentification_token

	def create
		order = Order.new(order_params)
		if charge_exist(@current_user, Constants::FREPI_ADMIN)
			order.pay_mode = params[:pay_mode]
			order.status = params[:status]
			order.due = params[:due]
			order.paid = params[:paid]
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
			response << {info: o, products: OrderProduct.where(order_id: o.id)}
		end
		render :json => response, status: :ok
	end

	private

	def order_params
		params.permit(:comment, :datehour)
	end

	def orderproduct_params(p)
		p.permit(:comment, :quantity, :variant_id)
	end

end