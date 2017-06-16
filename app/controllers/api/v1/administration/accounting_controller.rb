class Api::V1::Administration::AccountingController < ApplicationController
	before_action :validate_authentification_token

	def close_day
		response = []
		day = DateTime.parse params[:day]
		orders = Order.where(status: 3).where('datehour BETWEEN ? AND ?', day.beginning_of_day, day.end_of_day)
		orders.each do |o|
			response << {order: o, order_products: OrderProduct.where(order_id: o.id)}
		end
		render :json => response, status: :ok
	end

end