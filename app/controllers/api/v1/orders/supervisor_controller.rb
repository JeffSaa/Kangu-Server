class Api::V1::Orders::SupervisorController < ApplicationController
	before_action :validate_authentification_token

	def get_supervisor_orders
		response = {received: [], buying: [], deliver: [], completed: [], disabled: []}
		Order.where(status: 0).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_product = Product.find_by(id: p.product_id)
				temp_product.measure_description = p.quantity
				temp[:products] << temp_product
			end
			response[:received] << temp
		end
		Order.where(status: 1).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_product = Product.find_by(id: p.product_id)
				temp_product.measure_description = p.quantity
				temp[:products] << temp_product
			end
			response[:buying] << temp
		end
		Order.where(status: 2).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_product = Product.find_by(id: p.product_id)
				temp_product.measure_description = p.quantity
				temp[:products] << temp_product
			end
			response[:deliver] << temp
		end
		Order.where(status: 3).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_product = Product.find_by(id: p.product_id)
				temp_product.measure_description = p.quantity
				temp[:products] << temp_product
			end
			response[:completed] << temp
		end
		Order.where(status: 4).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_product = Product.find_by(id: p.product_id)
				temp_product.measure_description = p.quantity
				temp[:products] << temp_product
			end
			response[:disabled] << temp
		end
		render :json => response, status: :ok
	end

	def change_order_status
		order = Order.find(params[:id])
		order.update(status: params[:status])
		render :json => order, status: :ok
	end

end