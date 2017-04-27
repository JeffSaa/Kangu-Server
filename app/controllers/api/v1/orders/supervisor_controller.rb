class Api::V1::Orders::SupervisorController < ApplicationController
	before_action :validate_authentification_token

	def get_supervisor_orders
		response = {received: [], buying: [], deliver: [], completed: [], disabled: []}
		response.each_key.with_index do |key, index|
			Order.where(status: index).each do |o|
				temp_order = {info: o, products: []}
				OrderProduct.where(order_id: o.id).each do |op|
					temp_product = {order_product: op, product_info: Product.find(op.product_id)}
					temp_order[:products] << temp_product
				end
				response[key] << temp_order
			end
		end
		render :json => response, status: :ok
	end

	def change_order_status
		order = Order.find(params[:id])
		order.update(status: params[:status])
		render :json => order, status: :ok
	end

end