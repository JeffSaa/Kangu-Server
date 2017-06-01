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
		end
		response = {order_info: order, products: []}
		params[:products].each do |p|
			op = OrderProduct.new(orderproduct_params(p))
			if op
				response[:products] << op
			end
		end
		if order
			render :json => response, status: :ok
		end
	end

	private

	def order_params
		params.permit(:comment, :datehour)
	end

	def orderproduct_params(p)
		p.permit(:comment, :quantity, :variant_id)
	end

end